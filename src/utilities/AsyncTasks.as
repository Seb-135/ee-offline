package utilities 
{
	/**
	 * @author Remmoze
	 */
	public class AsyncTasks 
	{
		private var tasks:int;
		private var oc:Function;
		private var cur:int = 0;
		private var finish:Boolean = false;
		/**
		 * Wait for multiple async tasks
		 * @param	amount - How many tasks have to be done.
		 * @param	callback - execute when all tasks are finished
		 * @usage   use AsyncTasks.next() to mark task as finished
		 */
		public function AsyncTasks(amount:int, onComplete:Function) 
		{
			if (isNaN(amount) || amount <= 0) throw new Error("Provided invalid amount");
			tasks = amount;
			oc = onComplete;
		}
		
		public function get current():int {
			return cur;
		}
		
		public function get total():int {
			return tasks;
		}
		
		public function get completed():Boolean {
			return finish;
		}
		
		private function update():void {
			if (cur == tasks && !finish) {
				finish = true;
				oc();
			}
			else if (finish) throw new Error("Callback has been already called");
			else if (cur > tasks) throw new Error("Got more tasks than expected");
		}
		
		/**
		 * Add another task
		 */
		public function addTask():void {
			if (finish) throw new Error("Can't add any more tasks, callback has been already called");
			tasks++;
		}
		
		/**
		 * Mark task as finished
		 */
		public function next():void {
			cur++;
			update();
		}
		
	}

}