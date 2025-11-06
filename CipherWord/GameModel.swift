
import Foundation
import SwiftUI

enum GameMode: String, CaseIterable {
    case classic = "Classic"
    case timed = "Timed"
    case mosaic = "Mosaic"
}

enum CellState {
    case empty
    case filled
    case correct
    case wrongPosition
    case wrong
}

struct GameCell {
    var letter: String
    var state: CellState
}

class GameModel: ObservableObject {
    @Published var grid: [[GameCell]] = Array(repeating: Array(repeating: GameCell(letter: "", state: .empty), count: 5), count: 6)
    @Published var currentRow: Int = 0
    @Published var currentCol: Int = 0
    @Published var targetWord: String = ""
    @Published var gameMode: GameMode = .classic
    @Published var isGameOver: Bool = false
    @Published var hasWon: Bool = false
    @Published var timeRemaining: Int = 60
    @Published var timer: Timer?
    @Published var attemptsCount: Int = 0
    
    @Published var keyboardLetterStates: [String: CellState] = [:]
    
    let statsManager: GameStatsManager
    
    let englishWords = [
        "APPLE", "BEACH", "CHAIR", "DANCE", "EARTH", "FLAME", "GHOST", "HEART",
        "IMAGE", "JAZZY", "KNIFE", "LIGHT", "MAGIC", "NIGHT", "OCEAN", "PIANO",
        "QUIET", "RIVER", "STORM", "TIGER", "UNCLE", "VOICE", "WATER", "XENON",
        "YOUTH", "ZEBRA", "ABOUT", "AFTER", "AGAIN", "ALIVE", "AMONG", "ANGEL",
        "ARROW", "BASIC", "BLOOM", "BRAVE", "BRIGHT", "BROWN", "CANDY", "CLEAR",
        "CLOUD", "COAST", "COURT", "CRANE", "DREAM", "EARLY", "EAGLE", "FIELD",
        "FLAME", "FLASH", "FRAME", "FRESH", "FRUIT", "GIANT", "GLASS", "GRAND",
        "GREEN", "GROWN", "GUARD", "GUESS", "HAPPY", "HEART", "HEAVY", "HONEY",
        "HUMAN", "HURRY", "IMAGE", "INNER", "INPUT", "ISLAND", "JAZZY", "JOINT",
        "JUDGE", "KNIFE", "LABEL", "LARGE", "LAYER", "LEARN", "LEAST", "LEAVE",
        "LEVEL", "LIGHT", "LIMIT", "LOCAL", "MAGIC", "MAJOR", "MARCH", "MIGHT",
        "MODEL", "MONTH", "MORAL", "MOTOR", "MUSIC", "NIGHT", "NOISE", "NORTH",
        "OCEAN", "OFFER", "ONION", "ORDER", "OUTER", "OWNER", "PAINT", "PAPER",
        "PARTY", "PAUSE", "PEACE", "PHONE", "PIANO", "PLACE", "PLAIN", "PLANE",
        "PLANT", "PLATE", "POINT", "POUND", "POWER", "PRESS", "PRICE", "PRIDE",
        "PRIZE", "PROOF", "PULSE", "PURSE", "QUIET", "QUITE", "RADIO", "RAISE",
        "RANGE", "RAPID", "RATIO", "REACH", "REACT", "READY", "REALM", "REBEL",
        "REFER", "RELAX", "RELAY", "REMIT", "REPAY", "REPLY", "REUSE", "RIDER",
        "RIGID", "RISKY", "RIVER", "ROBOT", "ROCKY", "ROUND", "ROUTE", "ROYAL",
        "RUBY", "RULER", "RURAL", "RUSTY", "SAINT", "SALAD", "SALES", "SALON",
        "SAUCE", "SCALE", "SCARE", "SCENE", "SCENT", "SCOPE", "SCORE", "SCORN",
        "SCOUT", "SCRAP", "SEIZE", "SENSE", "SERVE", "SETUP", "SHADE", "SHAKE",
        "SHALL", "SHAME", "SHAPE", "SHARE", "SHARK", "SHARP", "SHEEP", "SHEER",
        "SHEET", "SHELF", "SHELL", "SHIFT", "SHINE", "SHIRT", "SHOCK", "SHOOT",
        "SHORE", "SHORT", "SHOUT", "SHOVE", "SHRED", "SHRUG", "SHRUN", "SIGHT",
        "SILLY", "SINCE", "SIXTH", "SIZED", "SKIES", "SKILL", "SKIRT", "SKULL",
        "SLATE", "SLAVE", "SLEEP", "SLEET", "SLICE", "SLIDE", "SLIME", "SLING",
        "SLINK", "SLOOP", "SLOPE", "SLOSH", "SLOTH", "SLUMP", "SLUNG", "SLURP",
        "SLUSH", "SMALL", "SMART", "SMEAR", "SMELL", "SMILE", "SMITE", "SMITH",
        "SMOCK", "SMOKE", "SMOKY", "SNAKE", "SNAKY", "SNARE", "SNARL", "SNEAK",
        "SNEER", "SNIFF", "SNIPE", "SNOOP", "SNORE", "SNORT", "SNOUT", "SNOWY",
        "SNUCK", "SNUFF", "SOAPY", "SOBER", "SOFTY", "SOGGY", "SOLAR", "SOLID",
        "SOLVE", "SONIC", "SORRY", "SOUND", "SOUTH", "SPACE", "SPADE", "SPANK",
        "SPARE", "SPARK", "SPASM", "SPATE", "SPAWN", "SPEAK", "SPEED", "SPELL",
        "SPEND", "SPENT", "SPERM", "SPICE", "SPICY", "SPIKE", "SPILL", "SPILT",
        "SPINE", "SPINY", "SPIRE", "SPITE", "SPLAT", "SPLIT", "SPOIL", "SPOKE",
        "SPOOF", "SPOOK", "SPOOL", "SPOON", "SPORE", "SPORT", "SPOUT", "SPRAY",
        "SPREE", "SPRIG", "SPUNK", "SPURN", "SPURT", "SQUAD", "SQUAT", "SQUAW",
        "SQUID", "SQUIT", "STACK", "STAFF", "STAGE", "STAID", "STAIN", "STAIR",
        "STAKE", "STALE", "STALK", "STALL", "STAMP", "STAND", "STANK", "STARE",
        "STARK", "START", "STATE", "STAVE", "STEAD", "STEAK", "STEAL", "STEAM",
        "STEED", "STEEL", "STEEP", "STEER", "STEMS", "STERN", "STICK", "STIFF",
        "STILL", "STILT", "STING", "STINK", "STINT", "STOCK", "STOIC", "STOKE",
        "STOLE", "STOMP", "STONE", "STONY", "STOOD", "STOOL", "STOOP", "STORE",
        "STORK", "STORM", "STORY", "STOUT", "STOVE", "STRAP", "STRAW", "STRAY",
        "STREAK", "STREAM", "STREET", "STRICT", "STRIDE", "STRIFE", "STRIKE",
        "STRING", "STRIP", "STRIVE", "STROKE", "STROLL", "STRONG", "STROVE",
        "STUCK", "STUDY", "STUFF", "STUMP", "STUNG", "STUNK", "STUNT", "STYLE",
        "SUAVE", "SUGAR", "SUING", "SUITE", "SULKY", "SULLY", "SUNNY", "SUPER",
        "SURGE", "SURLY", "SUSHI", "SWAMP", "SWANK", "SWARM", "SWASH", "SWATH",
        "SWEAR", "SWEAT", "SWEEP", "SWEET", "SWELL", "SWEPT", "SWIFT", "SWILL",
        "SWIM", "SWINE", "SWING", "SWIPE", "SWIRL", "SWISH", "SWISS", "SWOON",
        "SWOOP", "SWORD", "SWORE", "SWORN", "SWUNG", "SYNOD", "SYRUP", "TABBY",
        "TABLE", "TABOO", "TACIT", "TACKY", "TAFFY", "TAINT", "TAKEN", "TALKY",
        "TALLY", "TALON", "TAMER", "TANGO", "TANGY", "TAPER", "TAPIR", "TARDY",
        "TARRY", "TASTE", "TASTY", "TATTY", "TAUNT", "TAWNY", "TEACH", "TEARY",
        "TEASE", "TEDDY", "TEENS", "TEENY", "TEETH", "TELLS", "TEMPO", "TEMPT",
        "TENET", "TENOR", "TENSE", "TENTH", "TEPID", "TERMS", "TERRY", "TERSE",
        "TESTS", "TESTY", "TEXAS", "TEXTS", "THANK", "THANK", "THEFT", "THEIR",
        "THEME", "THERE", "THESE", "THICK", "THIEF", "THIGH", "THING", "THINK",
        "THIRD", "THONG", "THORN", "THOSE", "THREE", "THREW", "THROB", "THROW",
        "THRUM", "THRUST", "THUG", "THUMB", "THUMP", "THUNK", "THUS", "THYME",
        "TIARA", "TIBIA", "TIDAL", "TIGER", "TIGHT", "TILDE", "TIMER", "TIMID",
        "TINGE", "TIPSY", "TITAN", "TITHE", "TITLE", "TITTY", "TIZZY", "TOAST",
        "TODAY", "TODDY", "TOKEN", "TONAL", "TONGA", "TONGS", "TONIC", "TOOLS",
        "TOOTH", "TOPAZ", "TOPER", "TOPIC", "TORCH", "TORSO", "TORTE", "TOTAL",
        "TOTEM", "TOUCH", "TOUGH", "TOWEL", "TOWER", "TOXIC", "TRACE", "TRACK",
        "TRACT", "TRADE", "TRAIL", "TRAIN", "TRAIT", "TRAMP", "TRASH", "TRAWL",
        "TREAD", "TREAT", "TREND", "TRIAD", "TRIAL", "TRIBE", "TRICE", "TRICK",
        "TRIED", "TRIER", "TRIES", "TRIMS", "TRIMS", "TRIPS", "TRITE", "TROLL",
        "TROOP", "TROPE", "TROTS", "TROUT", "TRUCE", "TRUCK", "TRULY", "TRUMP",
        "TRUNK", "TRUSS", "TRUST", "TRUTH", "TRYST", "TUBAL", "TUBBY", "TUBER",
        "TUDOR", "TULIP", "TULLE", "TUMID", "TUMMY", "TUMOR", "TUNIC", "TUNNY",
        "TURBO", "TURF", "TURGY", "TURNS", "TUSKS", "TUTOR", "TUTTI", "TWAIN",
        "TWANG", "TWEED", "TWEEN", "TWEET", "TWERP", "TWICE", "TWIGS", "TWILL",
        "TWILT", "TWINE", "TWINS", "TWIRL", "TWIST", "TWITS", "TWIXT", "TYING",
        "TYPED", "TYPES", "TYPOS", "TYRAN", "UDDER", "ULCER", "ULTRA", "UMBRA",
        "UNCLE", "UNCUT", "UNDER", "UNDID", "UNDUE", "UNFED", "UNFIT", "UNIFY",
        "UNION", "UNITE", "UNITS", "UNITY", "UNLIT", "UNMET", "UNSET", "UNTIE",
        "UNTIL", "UNWED", "UNZIP", "UPPER", "UPSET", "URBAN", "URGED", "URINE",
        "USAGE", "USERS", "USHER", "USING", "USUAL", "USURP", "USURY", "UTTER",
        "VAGUE", "VALET", "VALID", "VALOR", "VALUE", "VALVE", "VAPID", "VAPOR",
        "VAULT", "VAUNT", "VEERS", "VEGAN", "VEILS", "VEINS", "VELLS", "VELUM",
        "VENAL", "VENDS", "VENOM", "VENTS", "VENUE", "VENUS", "VERBS", "VERGE",
        "VERSE", "VESTS", "VEXED", "VIALS", "VIBES", "VICAR", "VICES", "VIDEO",
        "VIEWS", "VIGIL", "VIGOR", "VILER", "VILLA", "VINED", "VINES", "VINYL",
        "VIOLA", "VIPER", "VIRAL", "VIROS", "VIRUS", "VISAS", "VISIT", "VISOR",
        "VISTA", "VITAL", "VITRO", "VIVID", "VIXEN", "VOCAL", "VODKA", "VOGUE",
        "VOICE", "VOIDS", "VOILE", "VOLES", "VOLTS", "VOMIT", "VOTER", "VOUCH",
        "VOUCH", "VOWED", "VOWEL", "VOWER", "VOWLS", "VROOM", "VULVA", "VYING",
        "WACKY", "WAFER", "WAFTS", "WAGED", "WAGER", "WAGES", "WAGON", "WAIFS",
        "WAILS", "WAINS", "WAIST", "WAITS", "WAIVE", "WAKED", "WAKEN", "WAKES",
        "WALKS", "WALLS", "WALTZ", "WANDS", "WANED", "WANES", "WANKS", "WANTS",
        "WARDS", "WARES", "WARMS", "WARNS", "WARPS", "WARTS", "WASTE", "WATCH",
        "WATER", "WATTS", "WAVED", "WAVER", "WAVES", "WAXED", "WAXEN", "WAXES",
        "WEARY", "WEAVE", "WEBER", "WEDGE", "WEEDS", "WEEKS", "WEEPS", "WEIRD",
        "WEIRS", "WELCH", "WELDS", "WELLS", "WELSH", "WELTS", "WENCH", "WENDS",
        "WENNY", "WESTS", "WETLY", "WHACK", "WHALE", "WHAMS", "WHARF", "WHATS",
        "WHEAL", "WHEAT", "WHEEL", "WHELK", "WHELM", "WHELP", "WHENS", "WHERE",
        "WHETS", "WHEWS", "WHEYS", "WHICH", "WHIFF", "WHIGS", "WHILE", "WHIMS",
        "WHINE", "WHIPS", "WHIRL", "WHIRR", "WHIRS", "WHISK", "WHIST", "WHITE",
        "WHITS", "WHOLE", "WHOMP", "WHOOP", "WHOPS", "WHOSE", "WHOSO", "WHUMP",
        "WHUPS", "WICKS", "WIDEN", "WIDER", "WIDES", "WIDOW", "WIDTH", "WIELD",
        "WIFES", "WIFEY", "WIGGY", "WIGHT", "WILCO", "WILDS", "WILES", "WILLS",
        "WILLY", "WILTS", "WIMPS", "WINCE", "WINCH", "WINDS", "WINDY", "WINED",
        "WINES", "WINGS", "WINKS", "WINOS", "WINPY", "WIPED", "WIPER", "WIPES",
        "WIRED", "WIRER", "WIRES", "WISER", "WISES", "WISPS", "WISPY", "WISTS",
        "WITCH", "WITHE", "WITHS", "WITTY", "WIVES", "WIZEN", "WIZES", "WOADS",
        "WOALF", "WODGE", "WOFUL", "WOKEN", "WOLDS", "WOLFS", "WOMAN", "WOMBS",
        "WOMEN", "WOMYN", "WONKS", "WONKY", "WOOED", "WOOER", "WOOFS", "WOOFY",
        "WOOLS", "WOOLY", "WOOPS", "WOOSE", "WOOSH", "WOOZY", "WORDS", "WORDY",
        "WORKS", "WORLD", "WORMS", "WORMS", "WORRY", "WORSE", "WORST", "WORTH",
        "WORTS", "WOULD", "WOUND", "WOVEN", "WOWED", "WRACK", "WRAPS", "WRAPT",
        "WRATH", "WREAK", "WRECK", "WRENS", "WREST", "WRICK", "WRING", "WRIST",
        "WRITE", "WRITS", "WRONG", "WROTE", "WROTH", "WRUNG", "WRYER", "WRYLY",
        "WURST", "WUSSY", "WYNDS", "WYNNS", "WYTHE", "XEBEC", "XENIA", "XENIC",
        "XENON", "XERIC", "XEROX", "XERUS", "XMAS", "XYLAN", "XYLEM", "XYLIC",
        "XYLOL", "XYLYL", "XYSTI", "XYSTS", "YACHT", "YACKS", "YAFFS", "YAGER",
        "YAGES", "YAGIS", "YAHOO", "YAIRD", "YAKOW", "YALKS", "YANGS", "YANKS",
        "YAPOK", "YAPON", "YAPPS", "YAPPY", "YARDS", "YARER", "YARKS", "YARNS",
        "YARRS", "YARTA", "YAUDS", "YAULD", "YAUPS", "YAWED", "YAWLS", "YAWN",
        "YAWS", "YAWNS", "YCLAD", "YEANS", "YEARD", "YEARN", "YEARS", "YEAST",
        "YECCH", "YECHS", "YECHY", "YEESH", "YELKS", "YELLS", "YELPS", "YENTA",
        "YENTE", "YERBA", "YERKS", "YESES", "YESKS", "YETIS", "YETTS", "YEUKS",
        "YEUKY", "YEXES", "YEXED", "YFERE", "YIELD", "YIKES", "YILLS", "YINCE",
        "YIPES", "YIPPY", "YIRDS", "YIRKS", "YIRRS", "YIRTH", "YITES", "YITIE",
        "YLEMS", "YLIKE", "YLKES", "YMOLT", "YMPES", "YOBBO", "YOBBY", "YOCKS",
        "YODEL", "YODHS", "YODLE", "YOHIM", "YOICK", "YOJAN", "YOKED", "YOKEL",
        "YOKER", "YOKES", "YOKUL", "YOLKS", "YOLKY", "YOMER", "YOMIM", "YONIC",
        "YONIS", "YONKS", "YOOFS", "YOOPS", "YORES", "YORKS", "YORPS", "YOUKS",
        "YOUNG", "YOURN", "YOURS", "YOURT", "YOUSE", "YOUTH", "YOWED", "YOWES",
        "YOWIE", "YOWLS", "YQUEM", "YRAIN", "YRENT", "YRIVD", "YRNEH", "YSAME",
        "YTOST", "YUANS", "YUCAS", "YUCCA", "YUCCH", "YUCHY", "YUCKS", "YUCKY",
        "YUFTS", "YUGAS", "YUKED", "YUKES", "YUKKY", "YUKOS", "YULAN", "YULES",
        "YUMAN", "YUMMY", "YUMPS", "YUNGE", "YUNKS", "YUNTS", "YUPON", "YUPPY",
        "YURTA", "YURTS", "YUSES", "YUSHI", "YUTZY", "YUZUS", "ZAIRE", "ZAKAT",
        "ZAMAN", "ZAMBI", "ZAMBO", "ZAMIA", "ZANTE", "ZANZA", "ZANZE", "ZAPPY",
        "ZARFS", "ZARIS", "ZATIS", "ZAXES", "ZAYIN", "ZAZEN", "ZEALS", "ZEBEC",
        "ZEBRA", "ZEBUS", "ZEDAS", "ZEINS", "ZELOS", "ZEMES", "ZEMNI", "ZERDA",
        "ZERKS", "ZEROS", "ZESTS", "ZETAS", "ZEXES", "ZEZES", "ZHUZH", "ZIBET",
        "ZIFFS", "ZIGGY", "ZILCH", "ZILLA", "ZILLS", "ZIMBI", "ZIMBS", "ZINCO",
        "ZINCS", "ZINCY", "ZINES", "ZINGS", "ZINGY", "ZINKE", "ZINKY", "ZIPPO",
        "ZIPPY", "ZIRAM", "ZITIS", "ZITTY", "ZIZEL", "ZIZIT", "ZLOTE", "ZLOTY",
        "ZOAEA", "ZOBOS", "ZOBUS", "ZOCCO", "ZOEAE", "ZOEAL", "ZOEAS", "ZOISM",
        "ZOIST", "ZOMBI", "ZONAE", "ZONAL", "ZONED", "ZONER", "ZONES", "ZONKS",
        "ZOOEA", "ZOOEY", "ZOOID", "ZOOKS", "ZOOMS", "ZOONS", "ZOOTY", "ZOPPA",
        "ZOPPO", "ZORIL", "ZORIS", "ZORRO", "ZOUKS", "ZOWEE", "ZOWIE", "ZUCCO",
        "ZUCHI", "ZUDDA", "ZUFFA", "ZULUS", "ZUPAN", "ZUPPA", "ZURFS", "ZWEIS",
        "ZWIES", "ZYDCO", "ZYGAL", "ZYGON", "ZYMES", "ZYMIN", "ZZZUS"
    ].filter { $0.count == 5 }
    
    init(statsManager: GameStatsManager = GameStatsManager()) {
        self.statsManager = statsManager
    }
    
    func startNewGame(mode: GameMode = .classic) {
        gameMode = mode
        currentRow = 0
        currentCol = 0
        isGameOver = false
        hasWon = false
        attemptsCount = 0
        grid = Array(repeating: Array(repeating: GameCell(letter: "", state: .empty), count: 5), count: 6)
        keyboardLetterStates = [:]
        
        targetWord = englishWords.randomElement() ?? "WORDS"
        targetWord = targetWord.uppercased()
        
        if mode == .timed {
            timeRemaining = 60
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func changeWordForMosaic() {
        targetWord = englishWords.randomElement() ?? "WORDS"
        targetWord = targetWord.uppercased()
        keyboardLetterStates = [:]
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                self.isGameOver = true
                self.hasWon = false
                self.statsManager.recordLoss()
            }
        }
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func addLetter(_ letter: String) {
        guard !isGameOver && currentCol < 5 && currentRow < 6 else { return }
        
        grid[currentRow][currentCol].letter = letter.uppercased()
        grid[currentRow][currentCol].state = .filled
        currentCol += 1
    }
    
    func deleteLetter() {
        guard currentCol > 0 else { return }
        currentCol -= 1
        grid[currentRow][currentCol].letter = ""
        grid[currentRow][currentCol].state = .empty
    }
    
    func submitWord() {
        guard currentCol == 5 else { return }
        
        let word = grid[currentRow].map { $0.letter }.joined()
        
        var targetWordArray = Array(targetWord)
        var wordArray = Array(word)
        
        for i in 0..<5 {
            if wordArray[i] == targetWordArray[i] {
                grid[currentRow][i].state = .correct
                targetWordArray[i] = " "
                wordArray[i] = " "
                let letter = String(Array(word)[i])
                keyboardLetterStates[letter] = .correct
            }
        }
        
        for i in 0..<5 {
            if wordArray[i] != " " {
                let letter = String(Array(word)[i])
                if let index = targetWordArray.firstIndex(of: wordArray[i]) {
                    grid[currentRow][i].state = .wrongPosition
                    targetWordArray[index] = " "
                    if keyboardLetterStates[letter] != .correct {
                        keyboardLetterStates[letter] = .wrongPosition
                    }
                } else {
                    grid[currentRow][i].state = .wrong
                    keyboardLetterStates[letter] = .wrong
                }
            }
        }
        
        attemptsCount += 1
        
        if word == targetWord {
            hasWon = true
            isGameOver = true
            stopTimer()
            statsManager.recordWin()
        } else if currentRow == 5 {
            hasWon = false
            isGameOver = true
            stopTimer()
            statsManager.recordLoss()
        } else {
            currentRow += 1
            currentCol = 0
            
            if gameMode == .mosaic && attemptsCount % 2 == 0 {
                changeWordForMosaic()
            }
        }
    }
    
}

