# ListOfMovie 📱💻
Practice Basic Swift concurrency by build movie lists app

## What did i learn 💬 ?
- Thread
- GCD
- Serial Queue and Concurrent Queue
- Sync and Async
- Main Dispatch Queue
- Global and private Queue
- Completion Block
- Operation Queue

</br>

- Struct is thread safe because immutable, using struct is safer rather than class
- Variables like NSMutableArray, NSMutableDictionary is mutable so isn't thread safe or non thread safe, Use DispatchBarrier to make non-thread safe class become thread safe
- NSArray, NSDictionary and the others immutable variable is safe to use because thread-safe
- Use GCD / Grand Central Dispatch for simple concurrency task, and use Operations for complex task like suspend and resum
