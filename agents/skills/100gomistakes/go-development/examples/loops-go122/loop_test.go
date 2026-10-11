package loop122

import "testing"

func TestDeclaredAndAssignedRangeVariables(t *testing.T) {
	var declared []*int
	for _, value := range []int{1, 2, 3} {
		declared = append(declared, &value)
	}
	for i, p := range declared {
		if *p != i+1 {
			t.Fatal("Go 1.22 language mode gives declarations distinct variables")
		}
	}
	var shared int
	var assigned []*int
	for _, shared = range []int{1, 2, 3} {
		assigned = append(assigned, &shared)
	}
	for _, p := range assigned {
		if *p != 3 {
			t.Fatal("assignment still reuses the existing variable")
		}
	}
}
