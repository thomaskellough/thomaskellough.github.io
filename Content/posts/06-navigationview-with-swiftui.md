---
date: 2020-09-05 20:48
description: SwiftUI brings an easy way to handle navigation in your apps. This section will show you how to easily add a navigation view as well as navigation bar items to help you handle navigation.
tags: NavigationView, NavigationLink, SwiftUI
featuredDescription: Learn how to handl NavigationView using SwiftUI
---
# All about NavigationView using SwiftUI

<div class="post-tags" markdown="1">
        <a class="post-category post-category-navigationview" href="/tags/navigationview">NavigationView</a>
        <a class="post-category post-category-navigationlink" href="/tags/navigationlink">NavigationLink</a>
        <a class="post-category post-category-swiftui" href="/tags/swiftui">SwiftUI</a>
</div>


### Basic NavigationView
Nearly all Swift apps have some sort of navigation in place and apps built with SwiftUI are no exception. It's simple to add a navigation view using SwiftUI. All you need to do is add the following code in your view

```
NavigationView {
    // Content here
}
```

Adding a title uses a simple modifier like most other views in SwiftUI, but there is a caveat. We do *not* attach the title to the NavigationView itself. Why? Because the title can change and we do not want to fix that title on every view we have during our navigation. For example, if you have an app that lists different Harry Potter spells by category, you may want the navigation title to be what category each set of spells is in. Let's see what I mean in action.

Take the following two structs, each one holding a view to different spells by two different categories.

```
struct CharmView: View {
    var body: some View {
        List() {
            VStack(alignment: .leading) {
                Text("Lumos Maxima")
                    .font(.headline)
                Text("incantation to a charm that can be used to produce a blinding flash of bright white light from the tip of the wand")
                    .font(.subheadline)
            }
            VStack(alignment: .leading) {
                Text("Oculus Reparo")
                    .font(.headline)
                Text("incantation of a variant of the Mending Charm, used to repair broken eyeglasses")
                    .font(.subheadline)
            }
            Spacer()
            .navigationBarTitle("Charm")
        }
    }
}

struct CurseView: View {
    var body: some View {
        List() {
            VStack(alignment: .leading) {
                Text("Fiendfyre")
                    .font(.headline)
                Text("A bewitched flame of abnormal size and heat, infused with dark magic, capable of seeking out living targets despite being non-sentient")
                    .font(.subheadline)
            }
            VStack(alignment: .leading) {
                Text("Imperius Curse")
                    .font(.headline)
                Text("places the victim completely under the caster's control, though a person with exceptional strength of will is capable of resisting it")
                    .font(.subheadline)
            }
            Spacer()
            .navigationBarTitle("Curse")
        }
    }
}
```

Note that we have a ```.navigationBarTitle()``` modifier added here, even though there is no navigation view. We wrap this entire view inside our NavigationView and then the title can adjust as needed. 

```
NavigationView {
    CharmView()
}
```

<img class="post-image img-md" src="/Images/Posts/06/06-01.png" alt="Navigation View Charm" width="800"/>


```
NavigationView {
    CurseView()
}
```
<img class="post-image img-md" src="/Images/Posts/06/06-02.png" alt="Navigation View Curse" width="800"/>

### Adding Navigation Bar Items
Adding navigation bar items is fairly simple to do as well. Let's create a bar button that toggles between both views created above. This also means we need to create a boolean that our button toggles and add both views in a Group so we can display each one depending on what the boolean equals. 

```
struct ContentView: View {
    
    @State private var typeToggled = false
    
    var body: some View {
        NavigationView {
            Group {
                if typeToggled {
                    CurseView()
                } else {
                    CharmView()
                }
            }
            .navigationBarItems(leading:
                Button(action: {
                    self.typeToggled.toggle()
                }) {
                    Text("Toggle Type")
                }
            )
        }
    }
}
```

Note that our `.navigationBarItems` is a modifier to the group itself, not each view. Remember, each view holds the title.

<img class="post-image img-md" src="/Images/Posts/06/06-03.png" alt="Leading bar button item " width="800"/>

You can also set your bar items as trailing instead of leading.

```
.navigationBarItems(trailing:
    Button(action: {
        self.typeToggled.toggle()
    }) {
        Text("Toggle Type")
    }
)
```

<img class="post-image img-md" src="/Images/Posts/06/06-04.png" alt="Trailing bar button item" width="800"/>


### Adding multiple navigation bar items
If you want to add multiple navigation bar items, just use an HStack. You can even mix custom buttons as well as default ones that Apples API provide. 

```
.navigationBarItems(trailing:
    HStack {
        Button(action: {
            self.typeToggled.toggle()
        }) {
            Text("Toggle Type")
        }
        
        Button(action: {
            // second action here
        }) {
            Image(systemName: "bolt")
        }
    }
)
```

<img class="post-image img-md" src="/Images/Posts/06/06-05.png" alt="Navigation View Charm" width="800"/>

It's also possible to add trailing and leding items.

```
.navigationBarItems(leading:
    EditButton(), trailing:
    HStack {
        Button(action: {
            self.typeToggled.toggle()
        }) {
            Text("Toggle Type")
        }
        
        Button(action: {
            // second action here
        }) {
            Image(systemName: "bolt")
        }
    }
)
```
<img class="post-image img-md" src="/Images/Posts/06/06-06.png" alt="Navigation View Charm" width="800"/>

### Using NavigationLink
NavigationLink can also be used to link to any view you'd like. This automatically pops a new view in your navigation stack and readjusts how the title is shown. Here is a new view that shows how to use the Lumos Maxima spell.

```
struct LumosMaximaHowTo: View {
    var body: some View {
        Text("To cast this light-creation spell, one must flick their wand, then draw it back and flick it a second time, after which it will light, as noted in chapter thirty-two of Extreme Incantations by Violeta Stitch.")
    }
}
```
We can then adjust our CharmView struct to add a navigation link inside of Lumos Maxima VStack and direct it to our new view.

```
VStack(alignment: .leading) {
    Text("Lumos Maxima")
        .font(.headline)
    Text("incantation to a charm that can be used to produce a blinding flash of bright white light from the tip of the wand")
        .font(.subheadline)
    NavigationLink("Click here to see how to use the spell", destination: LumosMaximaHowTo())
        .font(.footnote)
}
```

<img class="post-image img-md" src="/Images/Posts/06/06-07.gif" alt="NavigationLink example" width="800"/>


### Navigation Tags
While a simple boolean can control which views are shown, it may get complicated when you have more than two views. SwiftUI and NavigationLink have something called `tags` that we can use to control navigation with multiple views with ease. A tag is an optional string that's used to identify which view is shown based on what the value is. Codewise, it looks like this.

```
@State private var spellType: String? = nil

var body: some View {
    NavigationView {
        VStack(alignment: .center, spacing: 30) {
            NavigationLink(destination: CharmView(), tag: "Charm", selection: $spellType) {
                Text("Tap to see charms")
            }
            NavigationLink(destination: CurseView(), tag: "Curse", selection: $spellType) {
                Text("Tap to see curses")
            }
        }
    }
}
```

This shows the following view with each link showing it's respective content.

<img class="post-image img-md" src="/Images/Posts/06/06-08.gif" alt="NavigationLink example with tags" width="800"/>

### NavigationLink and isActive
NavigationLink also has an optional parameter of `isActive` that holds a boolean that determins whether a specific view is shown. Then you can create an action, such as a button tap, that toggles the boolean and shows the view attached to it.

```
@State private var charmViewShowing = false
@State private var curseViewShowing = false

var body: some View {
    NavigationView {
        VStack(spacing: 30) {
            NavigationLink(destination: CharmView(), isActive: $charmViewShowing) {
                EmptyView()
            }
            NavigationLink(destination: CurseView(), isActive: $curseViewShowing) {
                EmptyView()
            }
            Button("Toggle charmViewShowing") {
                self.charmViewShowing.toggle()
            }
            Button("Toggle curseViewShowing") {
                self.curseViewShowing.toggle()
            }
        }
    }
}
```
