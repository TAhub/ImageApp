//: Playground - noun: a place where people can play
//outputs the first 100 fibonacci numbers... in theory

func first100FibbNumberPrinter() -> [UInt]
{
	//the fibonacci numbers get pretty big, and they can't be negative, so unsigned ints are probably appropriate here
	//unfortunately, they're not enough. I can only go up to 94 numbers with them
	var fibNumbers = [UInt]()

	//the first two numbers are 0 and 1
	fibNumbers.append(0)
	fibNumbers.append(1)
	
	//now calculate the rest
	while (fibNumbers.count < 94)
	{
		fibNumbers.append(fibNumbers[fibNumbers.count - 2] + fibNumbers[fibNumbers.count - 1])
	}
	
	return fibNumbers
}

print(first100FibbNumberPrinter())