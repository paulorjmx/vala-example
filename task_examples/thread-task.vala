/*  
	TASK IN VALA
	The 'Task' class is one easy way to executed functions in another thread. Its uses a thread pool and automated all the
	process for manipulation o data like pass data among callback.
	This is an example on how to programming a task using Vala.
	The exemple below emulates a "long operation" to be executed in another thread and returns to main thread.
	Hopefully that helps you in something.
*/

/*  
	The function that will be executed must have this signature (because its a delegate - pointer function)  
	Case you pass a not null Object on create of Task, this must be Object instead Object?
*/
public void count_thread(Task task, Object? source_object, void *task_data, Cancellable? c = null)
{
	int i = 0;
	while(i < 100000) i++;
	task.return_int(i);
}

public void count_callback(Object? source_object, Task task) // The callback method have this signature
{
	int n = (int) task.propagate_int(); // Get the result returned by the thread
	// There is many types to return (pointers, bools and intergers). Also its possible return errors to return
	stdout.printf("Task finishes!\n"); 
	stdout.printf("Task result: %d\n", n);
}

public static void main(string[] args)
{
	//  MainLoop ml = new MainLoop(); // The task uses MainLoop to process callbacks
	Task t = new Task(null, null, count_callback); // This create a task with callback method
	t.set_task_data(null, null); // Set the data passed to function that will be executed in thread
	t.run_in_thread(count_thread); // Run the function in another thread
	stdout.printf("Task is runing...\n");
	/*  
		Another way to process the execution of the task is running each iteration of MainContext associated it.
		The loops below do this.
		For more, read the MainLoop and MainContext in Gnome Developer Manual.
	*/
	while(!t.get_context().iteration(true));
	//  ml.run();
}