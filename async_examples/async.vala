/*  
	When you run an program, this program become a process. Process concept is a abstraction of a running program 
	created by operating systems (read more on operating system books). Every process have at least one thread of execution 
	(read more about Threads in a operating system books).
	Your code, when running, runs in sequence os commands writed in lines of your source code.
	With Asynchronous execution you can run code in non-sequential.
	The example below show that. 
*/

public SourceFunc cb;

public async int long_operation()
{
	int i = 0;
	cb = long_operation.callback; // Register a callback to be resumed later
	yield; // 'Yield' gives up the CPU "returning" to the caller

	while(i < 1000000)
	{
		if(i == 50)
		{
			cb = long_operation.callback; // Register a callback at this point
			yield; // Return to the caller
		}
		i++;
		stdout.printf("%d\n", i);
	}
	return i;
}

public void terminated_method(Object? obj, AsyncResult res) // Callback to be called when the async method finishes
{
	int count = long_operation.end(res); // Get the return of the async method
	stdout.printf("The method finishes: %d\n", count); 
}

public static int main(string[] argv)
{
	long_operation.begin(terminated_method); // One way to call async methods. The parameter is a function pointer to method that will be called when the async method finishes
	/*  Another way to call async methods. In this way, the callback method is an anonymous method (read vala tutorial)  */
	//  long_operation.begin((obj, res) =>
	//  {
	//  	int count = long_operation.end(res);
	//  	stdout.printf("Done! (%d)\n", count);
	//  });
	stdout.printf("Started an long operation...\n"); // This string is printed before the begin of while in async method.
	cb(); // Calls the callback to executes back the async method.
	stdout.printf("Stoped the method...\n"); // This string is printed when i == 50
	cb(); // Return to execute the async method
	return 0;
}
