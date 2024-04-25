## Development Notes

Hi everyone, we would like to collect in this document the problems, reflections and adjustments that each of us encountered during the development process, as well as the solutions and ideas for adjustments, etc.

> Commit Templates

### Issue

### [JIRA Ticket Number](xxxxxxx): Data Binding Error
- **Problem Description**: The app crashes when trying to bind data from the view model to a SwiftUI view.
- **Solution**: Ensure all data binding operations are executed on the main thread, this can be achieved by inserting `DispatchQueue.main.async` before updating the data.

### Confusing
### [JIRA Ticket Number](xxxxxxx): Task & MainThread
- **Question Description**: Best practices on switching to the main thread
- **Practise**: **********

