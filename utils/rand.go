package utils

import (
	"math/rand"
	"time"
)

func RandomInt64s(ints []int64, length int) ([]int64, string) {
	rand.Seed(time.Now().Unix())
	newints := make([]int64, 0)
	if len(ints) <= 0 {
		return nil, "the length of the parameter strings should not be less than 0"
	}

	if length <= 0 || len(ints) <= length {
		return nil, "the size of the parameter length illegal"
	}

	for i := len(ints) - 1; i > 0; i-- {
		num := rand.Intn(i + 1)
		ints[i], ints[num] = ints[num], ints[i]
	}

	for i := 0; i < length; i++ {
		newints = append(newints, ints[i])
	}
	return newints, ""
}

func RandomString(strings []string, length int) (string, string) {
	rand.Seed(time.Now().Unix())
	if len(strings) <= 0 {
		return "", "the length of the parameter strings should not be less than 0"
	}

	if length <= 0 || len(strings) <= length {
		return "", "the size of the parameter length illegal"
	}

	for i := len(strings) - 1; i > 0; i-- {
		num := rand.Intn(i + 1)
		strings[i], strings[num] = strings[num], strings[i]
	}

	str := ""
	for i := 0; i < length; i++ {
		str += strings[i]
	}
	return str, ""
}
