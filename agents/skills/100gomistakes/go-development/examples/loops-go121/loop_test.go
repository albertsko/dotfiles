package loop121

import "testing"

func TestDeclaredRangeVariable(t *testing.T) {
	var values []*int
	for _, value := range []int{1, 2, 3} {
		values = append(values, &value)
	}
	for _, p := range values {
		if *p != 3 {
			t.Fatal("Go 1.21 language mode reuses the declared variable")
		}
	}
}
