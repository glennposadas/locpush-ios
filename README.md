# LocalPush

A super simple local push notification helper.

Sample usage:

    override func viewDidLoad() {
      super.viewDidLoad()
      
      LocalPush.shared.start()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
        LocalPush.shared.schedulePush(
          title: "Hello local push!🙇🏻‍♂️ ",
          subtitle: "This is a local push! Check out https://github.com/glennposadas/locpush-ios",
          hour: 23,
          minute: 19,
          repeats: true
        )
      }
    }



![enter image description here](https://i.imgur.com/yvNntoW.png)

