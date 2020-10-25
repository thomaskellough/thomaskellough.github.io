---
date: 2020-10-25 14:48
description: Learn how to implement UIColorWell in your apps to help users pick colors easier and more efficiently.
tags: UIColorWell, UIKit
---
# Using UIColorWell with UIKit

<div class="post-tags" markdown="1">
    <a class="post-category post-category-uicolorwell" href="/tags/uicolorwell">UIColorWell</a>
    <a class="post-category post-category-uikit" href="/tags/uikit">UIKit</a>
</div>


### UIColorWell
iOS 14 brought us many new features, one of them being the UIColorWell. This is not to be confused with UIColorPickerViewController, which while similar is handled just a bit differently. UIColorWell is a control that displays a color picker, but it also shows a little icon of the selected color in a wheel format to the user. While you can't add it using storyboard, it's very simple to add it in code.

```
class ViewController: UIViewController {
    
    var colorWell: UIColorWell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorWell = UIColorWell()
        colorWell.frame = CGRect(x: 200, y: 135, width: 100, height: 100)
        
        view.addSubview(colorWell)
    }
}
```

The above code will give you a color wheel displayed on the screen, in which you can click can and see various options for how the user can select their own color. 

<img class="post-image img-sm" src="/Images/Posts/09/09-01.gif" alt="Basic Color Picker"/>

You can customize your color well with a few different options, such as adding a custom title and turning off the alpha support which is true by default. You can also set a selected color that the color wheel will display in its inner circle.

```
colorWell.title = "My Custom Title"
colorWell.selectedColor = .systemRed
colorWell.supportsAlpha = false
```

<img class="post-image img-sm" src="/Images/Posts/09/09-02.png" alt="Color Picker Customized"/>

Finally, you can use the color selected by accessing the `colorWell.selectedColor` property.

```
class ViewController: UIViewController {
    
    var colorWell: UIColorWell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let changeBgBtn = UIButton()
        changeBgBtn.frame = CGRect(x: 80, y: 100, width: 100, height: 100)
        changeBgBtn.setTitle("Tap me", for: .normal)
        changeBgBtn.addTarget(self, action: #selector(changeBgColorWheel), for: .touchUpInside)
        view.addSubview(changeBgBtn)
        
        colorWell = UIColorWell()
        colorWell.frame = CGRect(x: 200, y: 135, width: 100, height: 100)
        colorWell.title = "My Custom Title"
        colorWell.selectedColor = .systemRed
        
        view.addSubview(colorWell)
        
    }
    
    @objc func changeBgColorWheel() {
        self.view.backgroundColor = colorWell?.selectedColor
    }
    
}
```

<img class="post-image img-sm" src="/Images/Posts/09/09-03.gif" alt="Using Color Picker Selected Color"/>

Feel free to download this project [here](https://github.com/thomaskellough/iOS-Tutorials-UIKit-Swift).
