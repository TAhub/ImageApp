//: Playground - noun: a place where people can play

import UIKit

func oddElements<T>(array:[T]) -> [T]
{
	return (array.enumerate().filter() { $0.index % 2 == 1 }).map() { $0.element }
}

//example
oddElements([0, 1, 2, 3, 4, 5])
oddElements(["A", "B", "C"])