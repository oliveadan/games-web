package front

import (
	"container/list"
	"encoding/json"
	"phage-games-web/utils"

	"github.com/astaxie/beego"
	"github.com/gorilla/websocket"
)

type WsController struct {
	beego.Controller
}

func init() {
	go func() {
		for {
			select {
			case sub := <-subscribe:
				subscribers.PushFront(sub)
				beego.Info("ws has connect num:", subscribers.Len())
			case event := <-publish:
				for sub := subscribers.Front(); sub != nil; sub = sub.Next() {
					// Immediately send event to WebSocket users.
					ws := sub.Value.(Subscriber).Conn
					if ws != nil {
						if ws.WriteMessage(websocket.TextMessage, event) != nil {
							subscribers.Remove(sub)
						}
					}
				}
			case unsub := <-unsubscribe:
				for sub := subscribers.Front(); sub != nil; sub = sub.Next() {
					suber := sub.Value.(Subscriber)
					if suber.Sesid == unsub {
						subscribers.Remove(sub)
						if suber.Conn != nil {
							suber.Conn.Close()
						}
					}
				}
			}
		}
	}()

}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

var (
	// Channel for new join users.
	subscribe = make(chan Subscriber, 10)
	// 退订
	unsubscribe = make(chan string, 10)
	// 发布
	publish = make(chan []byte, 10)
	// 订阅者
	subscribers = list.New()
)

type Subscriber struct {
	Sesid string
	Conn  *websocket.Conn
}

func (this *WsController) Join() {
	beego.Info("websocket join")
	var code int
	var msg string
	defer Retjson(this.Ctx, &msg, &code)
	conn, err := upgrader.Upgrade(this.Ctx.ResponseWriter, this.Ctx.Request, nil)
	if err != nil {
		msg = "ws连接失败"
		return
	}
	if this.CruSession == nil {
		this.StartSession()
	}
	subscribe <- Subscriber{Sesid: this.CruSession.SessionID(), Conn: conn}

	go func() {
		for {
			_, p, err := conn.ReadMessage()
			if err != nil {
				msg = "ws读取信息错误"
				unsubscribe <- this.CruSession.SessionID()
				return
			}
			publish <- p
		}
	}()
}

func Broadcast(account string, gift string, gameType string) {
	beego.Info("WsController broadcast", account, gameType, gift)
	m := map[string]string{
		"account": account,
		"game":    utils.GetGameTypeMap()[gameType],
		"gift":    gift}
	b, err := json.Marshal(m)
	if err != nil {
		beego.Error("WsController broadcast error", err)
		return
	}
	publish <- b
}
