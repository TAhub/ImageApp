//: Playground - noun: a place where people can play

import UIKit

//checks if a string is a palindrome
func isPalindrome(string:String) -> Bool
{
	//remove all the whitespace
	let noWhiteString = string.stringByReplacingOccurrencesOfString(" ", withString: "")
	
	//turn the string backwards
	var backString = ""
	for i in noWhiteString.startIndex..<noWhiteString.endIndex
	{
		backString = "\(noWhiteString.characters[i])\(backString)"
	}
	
	//then check if it's the same
	return backString == noWhiteString
}

//examples
isPalindrome("bob")
isPalindrome("not palindrome")
isPalindrome("a man a plan a canal panama")