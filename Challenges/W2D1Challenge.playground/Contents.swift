//: Playground - noun: a place where people can play

import UIKit

//I'm not 100% clear on what definition of "word" you're going by
//I assume it's based on whitespace separation though
func numWords(checkString:String)->Int
{
	var count = 0
	var word = ""
	for i in checkString.startIndex..<checkString.endIndex
	{
		//detect whitespace
		if checkString[i] == " " || checkString[i] == "\r" || checkString[i] == "\n"
		{
			//check out the word from before the punctuation
			if !word.isEmpty
			{
				count += 1
			}
			
			word = ""
		}
		else
		{
			word += "\(checkString[i])"
		}
	}
	
	//check out the final word
	if !word.isEmpty
	{
		count += 1
	}
	
	return count
}

//examples
numWords("hello\rthis should\nbe six! words")
numWords("and-this-should-be-but-a-single-word")
