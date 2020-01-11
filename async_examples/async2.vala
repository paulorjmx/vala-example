public async void awfully_long_operation ()
            {
                new Thread<void*> (null, () => {
                    var i = 0;
                    while (i < 100000000)
                        i++;
            
                    // here we call the callback. However we don't do it directly. If you want to
                    // continue your async method from a thread, glib requires you to schedule the
                    // callback with an idle, it will throw warnings otherwise. We will see the need
                    // for idles within threads further at the bottom in the part about notifications again.
                    Idle.add (awfully_long_operation.callback);
            
                    return null;
                });
            
                // we call a blank yield as above, so we just sit and wait here now.
                yield;
            }
            
            void main (string[] args)
            {
				MainLoop ml = new MainLoop();
                awfully_long_operation.begin ((obj, res) => {
                    awfully_long_operation.end (res);
            
                    print ("We're done\n");
					ml.quit();
                });
            
                print ("Continuing\n");
            
//                new MainLoop ().run ();
				ml.run();
            }
            
