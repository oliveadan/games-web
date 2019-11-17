package initial

import . "phage/initial"

func init() {
	InitLog()
	InitSql()
	InitBeeCache()
	InitFilter()
	InitMailConf()
	InitSysTemplateFunc()
	initTemplateFunc()

	InitFilterGame()
}
