//DescendantOfTheSunStrategyPattern 
 
 var str = "Hello, 太陽的後裔"

print(str)

class Soldier {
   
   //敬禮口號
   func salute() {
       print("團結 (단결)")
   }
   
   func backpacking() {
       print("背大杯包, 裡面一堆裝備")
   }
   
   func display() {
   }
}

class TitleRoleSoldier: Soldier {
   override func display() {
       print("劉時鎮報到😎")
   }
}

class SupportingRoleSoldier: Soldier {
   override func display() {
       print("徐大英報到😎")
   }
}

class FemaleSupportingRoleSoldier: Soldier {
   override func display() {
       print("尹明珠報到😏")
   }
}

/* 
 現在導演要為劉時鎮加幫女主角綁鞋帶的劇情, 這時要怎麼寫代碼呢？
 issue: 劉時鎮,徐大英,尹明珠搶著幫女主角綁鞋帶 ?
 其他角色都不需執行幫女主角綁鞋帶的Behavior !! 
 1.在基類(soldier類)中添加 TieShoelaces(), 其他演員重新改寫TieShoelaces code,
 這樣的話會被其他演員抱怨, 背這麼多台詞卻沒有用到, 一直mark(註解)掉方法
 2.使用protocol接口, 需要實現TieShoelaces()的演員，實現接口即可，頂多產生重複的code。
 
 */

//解决方案一:使用Swift Protocol Extensions Pattern
//求大大解指點issue: WWDC2015 介紹新的技術, 跟Strategy Pattern比較, 好像都改用這吧？
protocol SweetBehavioral {
   func shoesAction()
}
//為Protocol添加, 默認實現
extension SweetBehavioral {
   func shoesAction() {
       print("幫女主角綁鞋帶~👢")
   }
}

class Soldier {
   
   //敬禮口號
   func salute() {
       print("團結 (단결)")
   }
   
   func backpacking() {
       print("背大背包, 裡面一堆裝備")
   }
   
   func display() {
   }
}

class TitleRoleSoldier: Soldier, SweetBehavioral {
   override func display() {
       print("劉時鎮報到😎")
   }
}

class SupportingRoleSoldier: Soldier {
   override func display() {
       print("徐大英報到😎")
   }
}

class FemaleSupportingRoleSoldier: Soldier {
   override func display() {
       print("尹明珠報到😏")
   }
}

let titleRoleSoldier: TitleRoleSoldier = TitleRoleSoldier()
titleRoleSoldier.shoesAction()

//解決方案二:使用多態,行為代理--------策略模式（Strategy Pattern）--------------
//設計原則1：找出應用中可能需要變化之處，把它们獨立出来，不要和那些不變的code混在一起。
//設計原則2：針對接口编程(protocol)，而不是針對實現编程(Copy-Paste寫法導致不同viewController, 重複好幾個同func)
//設計原則3：多用组合，少用繼承 ("團結 (단결)")

//多態 oop 觀念：我卡這卡很久 >口<

//////劉時鎮的行為協議
protocol SweetBehavioral {
    func shoesAction()
}

////使用雙手綁鞋帶的類
class TieWithHands: SweetBehavioral {
    func shoesAction() {
        print("幫女主角綁鞋帶~👢")
    }
}

class TieMySelfWithHands: SweetBehavioral {
    func shoesAction() {
        print("綁自己鞋帶~👞")
    }
}

////使用雙手脫鞋子的類
class TakeOffShoesWithHands: SweetBehavioral {
    func shoesAction() {
        print("幫女主角脫鞋~👢")
    }
}
class Soldier {
    
    //添加行為委托代理者 
    var handleShoesActionBehavior: SweetBehavioral! = nil
    
    func setShoesActionBehavior(handleShoesActionBehavior: SweetBehavioral) {
        self.handleShoesActionBehavior = handleShoesActionBehavior
    }
    
    //敬禮口號
    func salute() {
        print("團結 (단결)")
    }

    func backpacking() {
        print("背大背包, 裡面一堆裝備")
    }

    func display() {
    }
    
    func performShoesAction() {
        guard (self.handleShoesActionBehavior != nil) else {
            return
        }
        self.handleShoesActionBehavior.shoesAction()
    }
}

////編劇: 劉時鎮角色藍圖
class TitleRoleSoldier: Soldier {
    
    override init() {
        super.init()
        self.setShoesActionBehavior(handleShoesActionBehavior: TieWithHands())
    }
    
    override func display() {
        print("劉時鎮報到😎")
    }
}

class SupportingRoleSoldier: Soldier {
    //先初始化綁自己鞋帶
    override init() {
        super.init()
        self.setShoesActionBehavior(handleShoesActionBehavior: TieMySelfWithHands())
    }
    override func display() {
        print("徐大英報到😎")
    }
}

class FemaleSupportingRoleSoldier: Soldier {
    override init() {
        super.init()
        self.setShoesActionBehavior(handleShoesActionBehavior: TieMySelfWithHands())
    }
    override func display() {
        print("尹明珠報到😏")
    }
}

////導演: 仲基哥這場景該你出場
var 宋仲基:Soldier = TitleRoleSoldier()
宋仲基.performShoesAction()

////導演: 仲基哥這次場景你要換TakeOffShoesWithHands()行為, 然後遇見伯母的劇情
宋仲基.setShoesActionBehavior(handleShoesActionBehavior: TakeOffShoesWithHands())
宋仲基.performShoesAction()


//現在好萊塢編劇新增需求,要創建 Winter Soldier版的劉時鎮,
//就算左手是iron hand當然還會幫女主角綁鞋帶
//在上面的基礎上進行擴充是非常easy 
class WinterSoldier: Soldier {
    
    override init() {
        super.init()
        self.setShoesActionBehavior(handleShoesActionBehavior: TieWithHands())
    }
    
    override func display() {
        print("The thing is, you don't have to. I'm with you till the end of the line")
    }
}

宋仲基 = WinterSoldier()
宋仲基.performShoesAction()

//現在給妳當編劇機會自訂SweetBehavioral需求
class SomeSweetAction: SweetBehavioral {
    func shoesAction() {
        print("函式名稱設不好, 反正sweetAction, 自訂SweetBehavioral需求po在issue區, Thank you :D")
    }
}

宋仲基.setShoesActionBehavior(handleShoesActionBehavior: SomeSweetAction())
宋仲基.performShoesAction()


///*
// 策略模式：
// 定義了演算法（就是上面仲基的各種sweet行為），分別封裝了起來，讓他們之間可以相互替換，此模式讓演算法的變化獨立於使用演算法的函式
// 演算法功能分開好以後換來換去
// */

