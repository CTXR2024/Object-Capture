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
---
### [TIW-84](https://chancetop.atlassian.net/browse/TIW-84): Collapse SideBar Not Work
- **Problem Description**:<br/> 
<body>I added NavigationView to the root view to try to achieve better interaction (left and right views can be more freely scaled or expanded) and introduced TitleBar.</body>

```
 NavigationView {
    //Sidebar
    //ModelViewer
    ...
 }
 .toolbar {
   ToolbarItem(placement: .navigation) {
   Button(action: toggleSidebar) {
     Label(String(localized: "ToggleSidebar",comment: "Button: Toggles Sidebar"),systemImage: "sidebar.left")
   }
 }
...
func toggleSidebar() {
   NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}
```
<body>However, when I click the toggle button on the titlelebar, the Sidebar doesn't collaspse properly!</body>

- **Solution**:<br/>
<body>
  <p>NavigationView is deprecated! Details refer to <a href=https://developer.apple.com/documentation/swiftui/navigationview>this</a></p>
  <p>So I replaced Navigation with <a href="https://developer.apple.com/documentation/swiftui/navigationsplitview">NavigationSpiltView</a>In addition, NavigationSpiltView comes with a toggle to collapse and expand the left sidebar.</p>
  <p>Please check the <a href=ObjectCapture/Views/Sidebar.swift>Sidebar.swif</a></p>
</body>

