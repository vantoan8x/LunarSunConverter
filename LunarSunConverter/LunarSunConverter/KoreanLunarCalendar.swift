//
//  KoreanLunarCalendar.swift
//  LunarSunConverter
//
//  Created by SwiftMan on 2022/12/06.
//

import Foundation

public final class KoreanLunarConverter {
  private let koreanLunarMinValue = 10000101
  private let koreanLunarMaxValue = 20501118
  private let koreanSolarMinValue = 10000213
  private let koreanSolarMaxValue = 20501231
  
  private let koreanLunarBaseYear = 1000
  private let solarLunarDayDiff = 43
   
  private let lunarSmallMonthDay = 29
  private let lunarBigMonthDay = 30
  private let solarSmallYearDay = 365
  private let solarBigYearDay = 366
  
  private let solarDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 29]
  private let koreanCheongan = ["\u{ac11}", "\u{c744}", "\u{bcd1}", "\u{c815}", "\u{bb34}", "\u{ae30}", "\u{acbd}", "\u{c2e0}", "\u{c784}", "\u{acc4}"]
  private let koreanGanji = ["\u{c790}", "\u{cd95}", "\u{c778}", "\u{bb18}", "\u{c9c4}", "\u{c0ac}", "\u{c624}", "\u{bbf8}", "\u{c2e0}", "\u{c720}", "\u{c220}", "\u{d574}"]
  private let koreanGapjaUnit = ["\u{b144}", "\u{c6d4}", "\u{c77c}"]
  
  private let chineseCheongan = ["\u{7532}", "\u{4e59}", "\u{4e19}", "\u{4e01}", "\u{620a}", "\u{5df1}", "\u{5e9a}", "\u{8f9b}", "\u{58ec}", "\u{7678}"]
  private let chineseGanji = ["\u{5b50}", "\u{4e11}", "\u{5bc5}", "\u{536f}", "\u{8fb0}", "\u{5df3}", "\u{5348}", "\u{672a}", "\u{7533}", "\u{9149}", "\u{620c}", "\u{4ea5}"]
  private let chineseGapjaUnit = ["\u{5e74}", "\u{6708}", "\u{65e5}"]
  
  private let intercalationStr = ["\u{c724}", "\u{958f}"]
  
  private let koreanLunarData = [
    0x82c60a57, 0x82fec52b, 0x82c40d2a, 0x82c60d55, 0xc30095ad, 0x82c4056a, 0x82c6096d, 0x830054dd, 0xc2c404ad, 0x82c40a4d,
    0x83002e4d, 0x82c40b26, 0xc300ab56, 0x82c60ad5, 0x82c4035a, 0x8300697a, 0xc2c6095b, 0x82c4049b, 0x83004a9b, 0x82c40a4b,
    0xc301caa5, 0x82c406aa, 0x82c60ad5, 0x830092dd, 0xc2c402b5, 0x82c60957, 0x82fe54ae, 0x82c60c97, 0xc2c4064b, 0x82ff254a,
    0x82c60da9, 0x8300a6b6, 0xc2c6066d, 0x82c4026e, 0x8301692e, 0x82c4092e, 0xc2c40c96, 0x83004d95, 0x82c40d4a, 0x8300cd69,
    0xc2c40b58, 0x82c80d6b, 0x8301926b, 0x82c4025d, 0xc2c4092b, 0x83005aab, 0x82c40a95, 0x82c40b4a, 0xc3021eab, 0x82c402d5,
    0x8301b55a, 0x82c604bb, 0xc2c4025b, 0x83007537, 0x82c4052b, 0x82c40695, 0xc3003755, 0x82c406aa, 0x8303cab5, 0x82c40275,
    0xc2c404b6, 0x83008a5e, 0x82c40a56, 0x82c40d26, 0xc3005ea6, 0x82c60d55, 0x82c405aa, 0x83001d6a, 0xc2c6096d, 0x8300b4af,
    0x82c4049d, 0x82c40a4d, 0xc3007d2d, 0x82c40aa6, 0x82c60b55, 0x830045d5, 0xc2c4035a, 0x82c6095d, 0x83011173, 0x82c4045b,
    0xc3009a4f, 0x82c4064b, 0x82c40aa5, 0x83006b69, 0xc2c606b5, 0x82c402da, 0x83002ab6, 0x82c60937, 0xc2fec497, 0x82c60c97,
    0x82c4064b, 0x82fe86aa, 0xc2c60da5, 0x82c405b4, 0x83034a6d, 0x82c402ae, 0xc2c40e61, 0x83002d2e, 0x82c40c96, 0x83009d4d,
    0x82c40d4a, 0x82c60d65, 0x83016595, 0x82c6055d, 0xc2c4026d, 0x83002a5d, 0x82c4092b, 0x8300aa97, 0xc2c40a95, 0x82c40b4a,
    0x83008b5a, 0x82c60ad5, 0xc2c6055b, 0x830042b7, 0x82c40457, 0x82c4052b, 0xc3001d2b, 0x82c40695, 0x8300972d, 0x82c405aa,
    0xc2c60ab5, 0x830054ed, 0x82c404b6, 0x82c60a57, 0xc2ff344e, 0x82c40d26, 0x8301be92, 0x82c60d55, 0xc2c405aa, 0x830089ba,
    0x82c6096d, 0x82c404ae, 0xc3004a9d, 0x82c40a4d, 0x82c40d25, 0x83002f25, 0xc2c40b54, 0x8303ad69, 0x82c402da, 0x82c6095d,
    0xc301649b, 0x82c4049b, 0x82c40a4b, 0x83004b4b, 0xc2c406a5, 0x8300bb53, 0x82c406b4, 0x82c60ab6, 0xc3018956, 0x82c60997,
    0x82c40497, 0x83004697, 0xc2c4054b, 0x82fec6a5, 0x82c60da5, 0x82c405ac, 0xc303aab5, 0x82c4026e, 0x82c4092e, 0x83006cae,
    0xc2c40c96, 0x82c40d4a, 0x83002f4a, 0x82c60d55, 0xc300b56b, 0x82c6055b, 0x82c4025d, 0x8300793d, 0xc2c40927, 0x82c40a95,
    0x83015d15, 0x82c40b4a, 0xc2c60b55, 0x830112d5, 0x82c604db, 0x82fe925e, 0xc2c60a57, 0x82c4052b, 0x83006aab, 0x82c40695,
    0xc2c406aa, 0x83003baa, 0x82c60ab5, 0x8300b4b7, 0xc2c404ae, 0x82c60a57, 0x82fe752e, 0x82c40d26, 0xc2c60e93, 0x830056d5,
    0x82c405aa, 0x82c609b5, 0xc300256d, 0x82c404ae, 0x8301aa4d, 0x82c40a4d, 0xc2c40d26, 0x83006d65, 0x82c40b52, 0x82c60d6a,
    0xc30026da, 0x82c6095d, 0x8301c49d, 0x82c4049b, 0xc2c40a4b, 0x83008aab, 0x82c406a5, 0x82c40b54, 0xc3004bb4, 0x82c60ab6,
    0x82c6095b, 0x83002537, 0xc2c40497, 0x8300964f, 0x82c4054b, 0x82c406a5, 0xc30176c5, 0x82c405ac, 0x82c60ab6, 0x8301386e,
    0xc2c4092e, 0x8300cc97, 0x82c40c96, 0x82c40d4a, 0xc3008daa, 0x82c60b55, 0x82c4056a, 0x83025adb, 0xc2c4025d, 0x82c4092e,
    0x83002d2b, 0x82c40a95, 0xc3009d4d, 0x82c40b2a, 0x82c60b55, 0x83007575, 0xc2c404da, 0x82c60a5b, 0x83004557, 0x82c4052b,
    0xc301ca93, 0x82c40693, 0x82c406aa, 0x83008ada, 0xc2c60ae5, 0x82c404b6, 0x83004aae, 0x82c60a57, 0xc2c40527, 0x82ff2526,
    0x82c60e53, 0x8300a6cb, 0xc2c405aa, 0x82c605ad, 0x830164ad, 0x82c404ae, 0xc2c40a4e, 0x83004d4d, 0x82c40d26, 0x8300bd53,
    0xc2c40b52, 0x82c60b6a, 0x8301956a, 0x82c60557, 0xc2c4049d, 0x83015a1b, 0x82c40a4b, 0x82c40aa5, 0xc3001ea5, 0x82c40b52,
    0x8300bb5a, 0x82c60ab6, 0xc2c6095b, 0x830064b7, 0x82c40497, 0x82c4064b, 0xc300374b, 0x82c406a5, 0x8300b6b3, 0x82c405ac,
    0xc2c60ab6, 0x830182ad, 0x82c4049e, 0x82c40a4d, 0xc3005d4b, 0x82c40b25, 0x82c40b52, 0x83012e52, 0xc2c60b5a, 0x8300a95e,
    0x82c6095b, 0x82c4049b, 0xc3006a57, 0x82c40a4b, 0x82c40aa5, 0x83004ba5, 0xc2c406d4, 0x8300cad6, 0x82c60ab6, 0x82c60937,
    0x8300849f, 0x82c40497, 0x82c4064b, 0x82fe56ca, 0xc2c60da5, 0x82c405aa, 0x83001d6c, 0x82c60a6e, 0xc300b92f, 0x82c4092e,
    0x82c40c96, 0x83007d55, 0xc2c40d4a, 0x82c60d55, 0x83013555, 0x82c4056a, 0xc2c60a6d, 0x83001a5d, 0x82c4092b, 0x83008a5b,
    0xc2c40a95, 0x82c40b2a, 0x83015b2a, 0x82c60ad5, 0xc2c404da, 0x83001cba, 0x82c60a57, 0x8300952f, 0xc2c40527, 0x82c40693,
    0x830076b3, 0x82c406aa, 0xc2c60ab5, 0x83003575, 0x82c404b6, 0x8300ca67, 0xc2c40a2e, 0x82c40d16, 0x83008e96, 0x82c40d4a,
    0xc2c60daa, 0x830055ea, 0x82c6056d, 0x82c404ae, 0xc301285d, 0x82c40a2d, 0x8300ad17, 0x82c40aa5, 0xc2c40b52, 0x83007d74,
    0x82c60ada, 0x82c6055d, 0xc300353b, 0x82c4045b, 0x82c40a2b, 0x83011a2b, 0xc2c40aa5, 0x83009b55, 0x82c406b2, 0x82c60ad6,
    0xc3015536, 0x82c60937, 0x82c40457, 0x83003a57, 0xc2c4052b, 0x82feaaa6, 0x82c60d95, 0x82c405aa, 0xc3017aac, 0x82c60a6e,
    0x82c4052e, 0x83003cae, 0xc2c40a56, 0x8300bd2b, 0x82c40d2a, 0x82c60d55, 0xc30095ad, 0x82c4056a, 0x82c60a6d, 0x8300555d,
    0xc2c4052b, 0x82c40a8d, 0x83002e55, 0x82c40b2a, 0xc300ab56, 0x82c60ad5, 0x82c404da, 0x83006a7a, 0xc2c60a57, 0x82c4051b,
    0x83014a17, 0x82c40653, 0xc301c6a9, 0x82c405aa, 0x82c60ab5, 0x830092bd, 0xc2c402b6, 0x82c60a37, 0x82fe552e, 0x82c40d16,
    0x82c60e4b, 0x82fe3752, 0x82c60daa, 0x8301b5b4, 0xc2c6056d, 0x82c402ae, 0x83007a3d, 0x82c40a2d, 0xc2c40d15, 0x83004d95,
    0x82c40b52, 0x8300cb69, 0xc2c60ada, 0x82c6055d, 0x8301925b, 0x82c4045b, 0xc2c40a2b, 0x83005aab, 0x82c40a95, 0x82c40b52,
    0xc3001eaa, 0x82c60ab6, 0x8300c55b, 0x82c604b7, 0xc2c40457, 0x83007537, 0x82c4052b, 0x82c40695, 0xc3014695, 0x82c405aa,
    0x8300cab5, 0x82c60a6e, 0xc2c404ae, 0x83008a5e, 0x82c40a56, 0x82c40d2a, 0xc3006eaa, 0x82c60d55, 0x82c4056a, 0x8301295a,
    0xc2c6095d, 0x8300b4af, 0x82c4049b, 0x82c40a4d, 0xc3007d2d, 0x82c40b2a, 0x82c60b55, 0x830045d5, 0xc2c402da, 0x82c6095b,
    0x83011157, 0x82c4049b, 0xc3009a4f, 0x82c4064b, 0x82c406a9, 0x83006aea, 0xc2c606b5, 0x82c402b6, 0x83002aae, 0x82c60937,
    0xc2ffb496, 0x82c40c96, 0x82c60e4b, 0x82fe76b2, 0xc2c60daa, 0x82c605ad, 0x8300336d, 0x82c4026e, 0xc2c4092e, 0x83002d2d,
    0x82c40c95, 0x83009d4d, 0xc2c40b4a, 0x82c60b69, 0x8301655a, 0x82c6055b, 0xc2c4025d, 0x83002a5b, 0x82c4092b, 0x8300aa97,
    0xc2c40695, 0x82c4074a, 0x83008b5a, 0x82c60ab6, 0xc2c6053b, 0x830042b7, 0x82c40257, 0x82c4052b, 0xc3001d2b, 0x82c40695,
    0x830096ad, 0x82c405aa, 0xc2c60ab5, 0x830054ed, 0x82c404ae, 0x82c60a57, 0xc2ff344e, 0x82c40d2a, 0x8301bd94, 0x82c60b55,
    0x82c4056a, 0x8300797a, 0x82c6095d, 0x82c404ae, 0xc3004a9b, 0x82c40a4d, 0x82c40d25, 0x83011aaa, 0xc2c60b55, 0x8300956d,
    0x82c402da, 0x82c6095b, 0xc30054b7, 0x82c40497, 0x82c40a4b, 0x83004b4b, 0xc2c406a9, 0x8300cad5, 0x82c605b5, 0x82c402b6,
    0xc300895e, 0x82c6092f, 0x82c40497, 0x82fe4696, 0xc2c40d4a, 0x8300cea5, 0x82c60d69, 0x82c6056d, 0xc301a2b5, 0x82c4026e,
    0x82c4092e, 0x83006cad, 0xc2c40c95, 0x82c40d4a, 0x83002f4a, 0x82c60b59, 0xc300c56d, 0x82c6055b, 0x82c4025d, 0x8300793b,
    0xc2c4092b, 0x82c40a95, 0x83015b15, 0x82c406ca, 0xc2c60ad5, 0x830112b6, 0x82c604bb, 0x8300925f, 0xc2c40257, 0x82c4052b,
    0x82fe6aaa, 0x82c60e95, 0xc2c406aa, 0x83003baa, 0x82c60ab5, 0x8300b4b7, 0xc2c404ae, 0x82c60a57, 0x82fe752d, 0x82c40d26,
    0xc2c60d95, 0x830055d5, 0x82c4056a, 0x82c6096d, 0xc300255d, 0x82c404ae, 0x8300aa4f, 0x82c40a4d, 0xc2c40d25, 0x83006d69,
    0x82c60b55, 0x82c4035a, 0xc3002aba, 0x82c6095b, 0x8301c49b, 0x82c40497, 0xc2c40a4b, 0x83008b2b, 0x82c406a5, 0x82c406d4,
    0xc3034ab5, 0x82c402b6, 0x82c60937, 0x8300252f, 0xc2c40497, 0x82fe964e, 0x82c40d4a, 0x82c60ea5, 0xc30166a9, 0x82c6056d,
    0x82c402b6, 0x8301385e, 0xc2c4092e, 0x8300bc97, 0x82c40a95, 0x82c40d4a, 0xc3008daa, 0x82c60b4d, 0x82c6056b, 0x830042db,
    0xc2c4025d, 0x82c4092d, 0x83002d2b, 0x82c40a95, 0xc3009b4d, 0x82c406aa, 0x82c60ad5, 0x83006575, 0xc2c604bb, 0x82c4025b,
    0x83013457, 0x82c4052b, 0xc2ffba94, 0x82c60e95, 0x82c406aa, 0x83008ada, 0xc2c609b5, 0x82c404b6, 0x83004aae, 0x82c60a4f,
    0xc2c20526, 0x83012d26, 0x82c60d55, 0x8301a5a9, 0xc2c4056a, 0x82c6096d, 0x8301649d, 0x82c4049e, 0xc2c40a4d, 0x83004d4d,
    0x82c40d25, 0x8300bd53, 0xc2c40b54, 0x82c60b5a, 0x8301895a, 0x82c6095b, 0xc2c4049b, 0x83004a97, 0x82c40a4b, 0x82c40aa5,
    0xc3001ea5, 0x82c406d4, 0x8302badb, 0x82c402b6, 0xc2c60937, 0x830064af, 0x82c40497, 0x82c4064b, 0xc2fe374a, 0x82c60da5,
    0x8300b6b5, 0x82c6056d, 0xc2c402ae, 0x8300793e, 0x82c4092e, 0x82c40c96, 0xc3015d15, 0x82c40d4a, 0x82c60da5, 0x83013555,
    0xc2c4056a, 0x83007a7a, 0x82c60a5d, 0x82c4092d, 0xc3006aab, 0x82c40a95, 0x82c40b4a, 0x83004baa, 0xc2c60ad5, 0x82c4055a,
    0x830128ba, 0x82c60a5b, 0xc3007537, 0x82c4052b, 0x82c40693, 0x83015715, 0xc2c406aa, 0x82c60ad5, 0x830035b5, 0x82c404b6,
    0xc3008a5e, 0x82c40a4e, 0x82c40d26, 0x83006ea6, 0xc2c40d52, 0x82c60daa, 0x8301466a, 0x82c6056d, 0xc2c404ae, 0x83003a9d,
    0x82c40a4d, 0x83007d2b, 0xc2c40b25, 0x82c40d52, 0x83015d54, 0x82c60b5a, 0xc2c6055d, 0x8300355b, 0x82c4049b, 0x83007657,
    0x82c40a4b, 0x82c40aa5, 0x83006b65, 0x82c406d2, 0xc2c60ada, 0x830045b6, 0x82c60937, 0x82c40497, 0xc3003697, 0x82c4064d,
    0x82fe76aa, 0x82c60da5, 0xc2c405aa, 0x83005aec, 0x82c60aae, 0x82c4092e, 0xc3003d2e, 0x82c40c96, 0x83018d45, 0x82c40d4a,
    0xc2c60d55, 0x83016595, 0x82c4056a, 0x82c60a6d, 0xc300455d, 0x82c4052d, 0x82c40a95, 0x83013c95, 0xc2c40b4a, 0x83017b4a,
    0x82c60ad5, 0x82c4055a, 0xc3015a3a, 0x82c60a5b, 0x82c4052b, 0x83014a17, 0xc2c40693, 0x830096ab, 0x82c406aa, 0x82c60ab5,
    0xc30064f5, 0x82c404b6, 0x82c60a57, 0x82fe452e, 0xc2c40d16, 0x82c60e93, 0x82fe3752, 0x82c60daa, 0xc30175aa, 0x82c6056d,
    0x82c404ae, 0x83015a1d, 0xc2c40a2d, 0x82c40d15, 0x83004da5, 0x82c40b52, 0xc3009d6a, 0x82c60ada, 0x82c6055d, 0x8301629b,
    0xc2c4045b, 0x82c40a2b, 0x83005b2b, 0x82c40a95, 0xc2c40b52, 0x83012ab2, 0x82c60ad6, 0x83017556, 0xc2c60537, 0x82c40457,
    0x83005657, 0x82c4052b, 0xc2c40695, 0x83003795, 0x82c405aa, 0x8300aab6, 0xc2c60a6d, 0x82c404ae, 0x83006a6e, 0x82c40a56,
    0xc2c40d2a, 0x83005eaa, 0x82c60d55, 0x82c405aa, 0xc3003b6a, 0x82c60a6d, 0x830074bd, 0x82c404ab, 0xc2c40a8d, 0x83005d55,
    0x82c40b2a, 0x82c60b55, 0xc30045d5, 0x82c404da, 0x82c6095d, 0x83002557, 0xc2c4049b, 0x83006a97, 0x82c4064b, 0x82c406a9,
    0x83004baa, 0x82c606b5, 0x82c402ba, 0x83002ab6, 0xc2c60937, 0x82fe652e, 0x82c40d16, 0x82c60e4b, 0xc2fe56d2, 0x82c60da9,
    0x82c605b5, 0x8300336d, 0xc2c402ae, 0x82c40a2e, 0x83002e2d, 0x82c40c95, 0xc3006d55, 0x82c40b52, 0x82c60b69, 0x830045da,
    0xc2c6055d, 0x82c4025d, 0x83003a5b, 0x82c40a2b, 0xc3017a8b, 0x82c40a95, 0x82c40b4a, 0x83015b2a, 0xc2c60ad5, 0x82c6055b,
    0x830042b7, 0x82c40257, 0xc300952f, 0x82c4052b, 0x82c40695, 0x830066d5, 0xc2c405aa, 0x82c60ab5, 0x8300456d, 0x82c404ae,
    0xc2c60a57, 0x82ff3456, 0x82c40d2a, 0x83017e8a, 0xc2c60d55, 0x82c405aa, 0x83005ada, 0x82c6095d, 0xc2c404ae, 0x83004aab,
    0x82c40a4d, 0x83008d2b, 0xc2c40b29, 0x82c60b55, 0x83007575, 0x82c402da, 0xc2c6095d, 0x830054d7, 0x82c4049b, 0x82c40a4b,
    0xc3013a4b, 0x82c406a9, 0x83008ad9, 0x82c606b5, 0xc2c402b6, 0x83015936, 0x82c60937, 0x82c40497, 0xc2fe4696, 0x82c40e4a,
    0x8300aea6, 0x82c60da9, 0xc2c605ad, 0x830162ad, 0x82c402ae, 0x82c4092e, 0xc3005cad, 0x82c40c95, 0x82c40d4a, 0x83013d4a,
    0xc2c60b69, 0x8300757a, 0x82c6055b, 0x82c4025d, 0xc300595b, 0x82c4092b, 0x82c40a95, 0x83004d95, 0xc2c40b4a, 0x82c60b55,
    0x830026d5, 0x82c6055b, 0xc3006277, 0x82c40257, 0x82c4052b, 0x82fe5aaa, 0xc2c60e95, 0x82c406aa, 0x83003baa, 0x82c60ab5,
    0x830084bd, 0x82c404ae, 0x82c60a57, 0x82fe554d, 0xc2c40d26, 0x82c60d95, 0x83014655, 0x82c4056a, 0xc2c609ad, 0x8300255d,
    0x82c404ae, 0x83006a5b, 0xc2c40a4d, 0x82c40d25, 0x83005da9, 0x82c60b55, 0xc2c4056a, 0x83002ada, 0x82c6095d, 0x830074bb,
    0xc2c4049b, 0x82c40a4b, 0x83005b4b, 0x82c406a9, 0xc2c40ad4, 0x83024bb5, 0x82c402b6, 0x82c6095b, 0xc3002537, 0x82c40497,
    0x82fe6656, 0x82c40e4a, 0xc2c60ea5, 0x830156a9, 0x82c605b5, 0x82c402b6, 0xc30138ae, 0x82c4092e, 0x83017c8d, 0x82c40c95,
    0xc2c40d4a, 0x83016d8a, 0x82c60b69, 0x82c6056d, 0xc301425b, 0x82c4025d, 0x82c4092d, 0x83002d2b, 0xc2c40a95, 0x83007d55,
    0x82c40b4a, 0x82c60b55, 0xc3015555, 0x82c604db, 0x82c4025b, 0x83013857, 0xc2c4052b, 0x83008a9b, 0x82c40695, 0x82c406aa,
    0xc3006aea, 0x82c60ab5, 0x82c404b6, 0x83004aae, 0xc2c60a57, 0x82c40527, 0x82fe3726, 0x82c60d95, 0xc30076b5, 0x82c4056a,
    0x82c609ad, 0x830054dd, 0xc2c404ae, 0x82c40a4e, 0x83004d4d, 0x82c40d25, 0xc3008d59, 0x82c40b54, 0x82c60d6a, 0x8301695a,
    0xc2c6095b, 0x82c4049b, 0x83004a9b, 0x82c40a4b, 0xc300ab27, 0x82c406a5, 0x82c406d4, 0x83026b75, 0xc2c402b6, 0x82c6095b,
    0x830054b7, 0x82c40497, 0xc2c4064b, 0x82fe374a, 0x82c60ea5, 0x830086d9, 0xc2c605ad, 0x82c402b6, 0x8300596e, 0x82c4092e,
    0xc2c40c96, 0x83004e95, 0x82c40d4a, 0x82c60da5, 0xc3002755, 0x82c4056c, 0x83027abb, 0x82c4025d, 0xc2c4092d, 0x83005cab,
    0x82c40a95, 0x82c40b4a, 0xc3013b4a, 0x82c60b55, 0x8300955d, 0x82c404ba, 0xc2c60a5b, 0x83005557, 0x82c4052b, 0x82c40a95,
    0xc3004b95, 0x82c406aa, 0x82c60ad5, 0x830026b5, 0xc2c404b6, 0x83006a6e, 0x82c60a57, 0x82c40527, 0xc2fe56a6, 0x82c60d93,
    0x82c405aa, 0x83003b6a, 0xc2c6096d, 0x8300b4af, 0x82c404ae, 0x82c40a4d, 0xc3016d0d, 0x82c40d25, 0x82c40d52, 0x83005dd4,
    0xc2c60b6a, 0x82c6096d, 0x8300255b, 0x82c4049b, 0xc3007a57, 0x82c40a4b, 0x82c40b25, 0x83015b25, 0xc2c406d4, 0x82c60ada,
    0x830138b6]
  
  private var lunarYear = 0
  private var lunarMonth = 0
  private var lunarDay = 0
  private var isIntercalation = false
  
  private var solarYear = 0
  private var solarMonth = 0
  private var solarDay = 0
  
  private var __gapjaYearInx = [0, 0, 0]
  private var __gapjaMonthInx = [0, 0, 1]
  private var __gapjaDayInx = [0, 0, 2]
  
  public var lunarIsoFormat: String {
    var dateStr = String(format: "%04d-%02d-%02d", self.lunarYear, self.lunarMonth, self.lunarDay)
    if self.isIntercalation {
      dateStr += " Intercalation"
    }
    return dateStr
  }
  
  public var solarIsoFormat: String {
    return String(format: "%04d-%02d-%02d", self.solarYear, self.solarMonth, self.solarDay)
  }
  
  private func lunar(year: Int) -> Int {
    return koreanLunarData[year - koreanLunarBaseYear]
  }

  private func lunarIntercalationMonth(lunar: Int) -> Int {
    return (lunar >> 12) & 0x000F
  }

  private func lunarDays(year: Int,
                         month: Int? = nil,
                         isIntercalation: Bool? = nil) -> Int {
    let lunar = lunar(year: year)
    
    guard
      let month,
      let isIntercalation
    else { return (lunar >> 17) & 0x01FF }
    
    if isIntercalation && lunarIntercalationMonth(lunar: lunar) == month {
      return ((lunar >> 16) & 0x01) > 0 ? lunarBigMonthDay : lunarSmallMonthDay
    }
    return ((lunar >> (12 - month)) & 0x01) > 0 ? lunarBigMonthDay : lunarSmallMonthDay
  }

  private func lunarDaysBeforeBaseYear(year: Int) -> Int {
    var days = 0
    for baseYear in koreanLunarBaseYear ... year {
      days += lunarDays(year: baseYear)
    }
    return days
  }

  private func lunarDaysBeforeBaseMonth(year: Int,
                                        month: Int,
                                        isIntercalation: Bool) -> Int {
    var days = 0
    if year >= koreanLunarBaseYear && month > 0 {
      for baseMonth in 1 ... month {
        days += lunarDays(year: year, month: baseMonth, isIntercalation: false)
      }
    }
    
    var intercalationMonth = 0
    if isIntercalation {
      intercalationMonth = lunarIntercalationMonth(lunar: lunar(year: year))
    }
    if intercalationMonth > 0 && intercalationMonth < month + 1 {
      days += lunarDays(year: year, month: intercalationMonth, isIntercalation: true)
    }
    return days
  }

  private func lunarAbsDays(year: Int,
                            month: Int,
                            day: Int,
                            isIntercalation: Bool) -> Int {
    var days = lunarDaysBeforeBaseYear(year: year - 1) + lunarDaysBeforeBaseMonth(year: year,
                                                                                  month: month - 1,
                                                                                  isIntercalation: true) + day
    if isIntercalation && lunarIntercalationMonth(lunar: lunar(year: year)) == month {
      days += lunarDays(year: year, month: month, isIntercalation: false)
    }
    return days
  }

  private func isSolarIntercalationYear(lunar: Int) -> Bool {
    return (lunar >> 30) & 0x01 > 0
  }

  private func solarDays(year: Int, month: Int? = nil) -> Int {
    let lunar = lunar(year: year)
    if let month {
      return month == 2 && isSolarIntercalationYear(lunar: lunar) ? solarDays[12] : solarDays[month - 1]
    }
     
    return isSolarIntercalationYear(lunar: lunar) ? solarBigYearDay : solarSmallYearDay
  }

  private func solarDaysBeforeBaseYear(year: Int) -> Int {
    var days = 0
    for baseYear in koreanLunarBaseYear ..< year + 1 {
      days += solarDays(year: baseYear)
    }
    return days
  }

  private func solarDaysBeforeBaseMonth(year: Int, month: Int) -> Int {
    var days = 0
    for baseMonth in 1 ..< month + 1 {
      days += solarDays(year: year, month: baseMonth)
    }
    return days
  }
   
  private func solarAbsDays(year: Int, month: Int, day: Int) -> Int {
    var days = solarDaysBeforeBaseYear(year: year-1) + solarDaysBeforeBaseMonth(year: year, month: month-1) + day
    days -= solarLunarDayDiff
    return days
  }

  private func solarDateByLunarDate(lunarYear: Int, lunarMonth: Int, lunarDay: Int, isIntercalation: Bool) {
    let absDays = lunarAbsDays(year: lunarYear, month: lunarMonth, day: lunarDay, isIntercalation: isIntercalation)
    var solarYear = 0
    var solarMonth = 0
    var solarDay = 0
    
    solarYear = absDays < solarAbsDays(year: lunarYear+1, month: 1, day: 1) ? lunarYear : lunarYear+1
                              
    for month in stride(from: 12, through: 1, by: -1) {
      let absDaysByMonth = solarAbsDays(year: solarYear, month: month, day: 1)
      if absDays >= absDaysByMonth {
        solarMonth = month
        solarDay = absDays - absDaysByMonth + 1
        break
      }
    }
    
    self.solarYear = solarYear
    self.solarMonth = solarMonth
    self.solarDay = solarDay
  }

  private func lunarDateBySolarDate(solarYear: Int, solarMonth: Int, solarDay: Int) {
    let absDays = solarAbsDays(year: solarYear, month: solarMonth, day: solarDay)
    let lunarYear = absDays >= lunarAbsDays(year: solarYear,
                                            month: 1,
                                            day: 1,
                                            isIntercalation: false) ? solarYear : solarYear - 1
    var lunarMonth = 0
    var lunarDay = 0
    var isIntercalation = false
                              
    for month in stride(from: 12, through: 1, by: -1) {
      let absDaysByMonth = lunarAbsDays(year: lunarYear,
                                        month: month,
                                        day: 1,
                                        isIntercalation: false)
      if absDays >= absDaysByMonth {
        lunarMonth = month
        if lunarIntercalationMonth(lunar: lunar(year: lunarYear)) == month {
          isIntercalation = absDays >= lunarAbsDays(year: lunarYear,
                                                    month: month,
                                                    day: 1,
                                                    isIntercalation: true)
        }
            
        lunarDay = absDays - lunarAbsDays(year: lunarYear,
                                          month: lunarMonth,
                                          day: 1,
                                          isIntercalation: isIntercalation) + 1
        break
      }
    }
                              
    self.lunarYear = lunarYear
    self.lunarMonth = lunarMonth
    self.lunarDay = lunarDay
    self.isIntercalation = isIntercalation
  }

  private func checkValidDate(isLunar: Bool,
                              isIntercalation: Bool,
                              year: Int,
                              month: Int,
                              day: Int) -> Bool {
    var isValid = false
    let dateValue = year*10000 + month*100 + day
    /// 1582. 10. 5 ~ 1582. 10. 14 is not valid
    let minValue = isLunar ? koreanLunarMinValue : koreanSolarMinValue
    let maxValue = isLunar ? koreanLunarMaxValue : koreanSolarMaxValue
    
    if minValue <= dateValue && maxValue >= dateValue {
      if month > 0 && month < 13 && day > 0 {
        var dayLimit: Int
        
        if isLunar {
          dayLimit = lunarDays(year: year,
                               month: month,
                               isIntercalation: isIntercalation)
        } else {
          dayLimit = solarDays(year: year, month: month)
        }
        
        if !isLunar && year == 1582 && month == 10 {
          if day > 4 && day < 15 {
            return isValid
          } else {
            dayLimit += 10
          }
        }
        
        if day <= dayLimit {
          isValid = true
        }
      }
    }
        
    return isValid
  }

  public func lunarDate(lunarYear: Int,
                         lunarMonth: Int,
                         lunarDay: Int,
                         isIntercalation: Bool) -> Bool {
    var isValid = false
    if checkValidDate(isLunar: true,
                      isIntercalation: isIntercalation,
                      year: lunarYear,
                      month: lunarMonth,
                      day: lunarDay) {
      self.lunarYear = lunarYear
      self.lunarMonth = lunarMonth
      self.lunarDay = lunarDay
      
      self.isIntercalation = isIntercalation && lunarIntercalationMonth(lunar: lunar(year: lunarYear)) == lunarMonth
      solarDateByLunarDate(lunarYear: lunarYear,
                           lunarMonth: lunarMonth,
                           lunarDay: lunarDay,
                           isIntercalation: isIntercalation)
      isValid = true
    }
    return isValid
  }

  public func solarDate(solarYear: Int, solarMonth: Int, solarDay: Int) -> Bool {
    var isValid = false
    if checkValidDate(isLunar: false,
                      isIntercalation: false,
                      year: solarYear,
                      month: solarMonth,
                      day: solarDay) {
      self.solarYear = solarYear
      self.solarMonth = solarMonth
      self.solarDay = solarDay
      lunarDateBySolarDate(solarYear: solarYear,
                           solarMonth: solarMonth,
                           solarDay: solarDay)
      isValid = true
    }
    return isValid
  }

  private func gapJa() {
    let absDays = lunarAbsDays(year: self.lunarYear,
                               month: self.lunarMonth,
                               day: self.lunarDay,
                               isIntercalation: self.isIntercalation)
    if absDays > 0 {
      self.__gapjaYearInx[0] = ((self.lunarYear + 6) - koreanLunarBaseYear) % koreanCheongan.count
      self.__gapjaYearInx[1] = ((self.lunarYear + 0) - koreanLunarBaseYear) % koreanGanji.count
      
      var monthCount = self.lunarMonth
      monthCount += 12 * (self.lunarYear - koreanLunarBaseYear)
      self.__gapjaMonthInx[0] = (monthCount + 3) % koreanCheongan.count
      self.__gapjaMonthInx[1] = (monthCount + 1) % koreanGanji.count
      
      self.__gapjaDayInx[0] = (absDays + 4) % koreanCheongan.count
      self.__gapjaDayInx[1] = (absDays + 2) % koreanGanji.count
    }
  }

  public var gapJaString: String {
    gapJa()
    var gapjaStr = String(format: "%s%s%s %s%s%s %s%s%s",
                          koreanCheongan[__gapjaYearInx[0]], koreanGanji[__gapjaYearInx[1]], koreanGapjaUnit[__gapjaYearInx[2]],
                          koreanCheongan[__gapjaMonthInx[0]], koreanGanji[__gapjaMonthInx[1]], koreanGapjaUnit[__gapjaMonthInx[2]],
                          koreanCheongan[__gapjaDayInx[0]], koreanGanji[__gapjaDayInx[1]], koreanGapjaUnit[__gapjaDayInx[2]])
    
    if self.isIntercalation {
      gapjaStr += " (\(intercalationStr[0])\(koreanGapjaUnit[0]))"
      
    }
    
    print("gapjaStr : \(gapjaStr)")
    return gapjaStr
  }
       
   
  public var chineseGapJaString: String {
    gapJa()
    var gapjaStr = String(format: "%s%s%s %s%s%s %s%s%s",
                          chineseCheongan[__gapjaYearInx[0]], chineseGanji[__gapjaYearInx[1]], chineseGapjaUnit[__gapjaYearInx[2]],
                          chineseCheongan[__gapjaMonthInx[0]], chineseGanji[__gapjaMonthInx[1]], chineseGapjaUnit[__gapjaMonthInx[2]],
                          chineseCheongan[__gapjaDayInx[0]], chineseGanji[__gapjaDayInx[1]], chineseGapjaUnit[__gapjaDayInx[2]])
    
    if self.isIntercalation {
      gapjaStr += " (\(intercalationStr[1])\(chineseGapjaUnit[1]))"
    }
    
    print("chineseGapJaString : \(gapjaStr)")
    return gapjaStr
  }
}
