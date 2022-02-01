//
//  MarketDataModel.swift
//  nftApp
//
//  Created by Adam Reed on 1/18/22.
//

import Foundation


// MARK: JSON DATA URL & RESPONSE
/*
    URL: https://api.coingecko.com/api/v3/global
 
    JSON Response:
     {
       "data": {
         "active_cryptocurrencies": 12564,
         "upcoming_icos": 0,
         "ongoing_icos": 50,
         "ended_icos": 3375,
         "markets": 720,
         "total_market_cap": {
           "btc": 50177526.99329612,
           "eth": 669033000.9372606,
           "ltc": 14841956190.121431,
           "bch": 5537142091.67817,
           "bnb": 4519007373.102557,
           "eos": 748174939628.5093,
           "xrp": 2798624368800.7227,
           "xlm": 8297539255553.677,
           "link": 92285969106.91798,
           "dot": 83480304462.66254,
           "yfi": 63873599.37590181,
           "usd": 2125383213141.042,
           "aed": 7806532541867.045,
           "ars": 221393534936400.97,
           "aud": 2958599319571.9365,
           "bdt": 182763568584459.38,
           "bhd": 801205709857.7788,
           "bmd": 2125383213141.042,
           "brl": 11832220885877.498,
           "cad": 2658960668800.1,
           "chf": 1949552385301.0964,
           "clp": 1738350930028059,
           "cny": 13503197168048.992,
           "czk": 45758155211352.73,
           "dkk": 13968656091726.863,
           "eur": 1876826022513.835,
           "gbp": 1563406386987.9905,
           "hkd": 16560454650991.717,
           "huf": 671493572359779.5,
           "idr": 30521459363151284,
           "ils": 6656880881130.852,
           "inr": 158565069020439.03,
           "jpy": 243575292375602.78,
           "krw": 2536177280576942.5,
           "kwd": 642669125223.1594,
           "lkr": 430469717516225.06,
           "mmk": 3779636559365657.5,
           "mxn": 43385234991526.766,
           "myr": 8891540672175.562,
           "ngn": 880971341846962.5,
           "nok": 18735996907962.867,
           "nzd": 3141269630591.772,
           "php": 109404100896434.89,
           "pkr": 374279983834137.4,
           "pln": 8506975958973.029,
           "rub": 163668960017709.72,
           "sar": 7974563213314.787,
           "sek": 19420227901919.008,
           "sgd": 2871562751610.598,
           "thb": 70363750676017.82,
           "try": 28753671875621.203,
           "twd": 58686081281250.23,
           "uah": 60492170299664.555,
           "vef": 212814621131.81253,
           "vnd": 48363095015024390,
           "zar": 33007203425463.605,
           "xdr": 1510849910893.4434,
           "xag": 90540092157.54478,
           "xau": 1172127588.2151544,
           "bits": 50177526993296.12,
           "sats": 5017752699329612
         },
         "total_volume": {
           "btc": 2097200.003894269,
           "eth": 27962637.7832147,
           "ltc": 620328510.4879689,
           "bch": 231428193.29820794,
           "bnb": 188874638.67510065,
           "eos": 31270422843.12133,
           "xrp": 116970193408.12923,
           "xlm": 346800657620.78973,
           "link": 3857147738.5936666,
           "dot": 3489109673.890091,
           "yfi": 2669635.6095384927,
           "usd": 88831673260.25702,
           "aed": 326278735884.9239,
           "ars": 9253276320150.63,
           "aud": 123656442960.14877,
           "bdt": 7638713577858.625,
           "bhd": 33486875868.919098,
           "bmd": 88831673260.25702,
           "brl": 494534808207.17694,
           "cad": 111132864832.2445,
           "chf": 81482717763.1092,
           "clp": 72655425559564.25,
           "cny": 564374269724.3914,
           "czk": 1912489694844.1602,
           "dkk": 583828406168.387,
           "eur": 78443075567.48967,
           "gbp": 65343512870.16584,
           "hkd": 692154190125.6077,
           "huf": 28065478849845.547,
           "idr": 1275662802270258,
           "ils": 278228351343.35175,
           "inr": 6627322693914.122,
           "jpy": 10180376250645.232,
           "krw": 106001059067999.48,
           "kwd": 26860743697.08989,
           "lkr": 17991741469682.367,
           "mmk": 157972189583588,
           "mxn": 1813312063094.2998,
           "myr": 371627305084.28577,
           "ngn": 36820728566376.56,
           "nok": 783082290874.806,
           "nzd": 131291258781.84819,
           "php": 4572610381071.72,
           "pkr": 15643257661131.256,
           "pln": 355554190956.2479,
           "rub": 6840642896417.965,
           "sar": 333301679141.2076,
           "sek": 811680137942.5005,
           "sgd": 120018697108.46802,
           "thb": 2940895397484.921,
           "try": 1201777058036.0386,
           "twd": 2452820162062.207,
           "uah": 2528306741880.26,
           "vef": 8894715443.549534,
           "vnd": 2021364725037147.8,
           "zar": 1379555974563.465,
           "xdr": 63146883253.7864,
           "xag": 3784177758.516459,
           "xau": 48989779.48629919,
           "bits": 2097200003894.269,
           "sats": 209720000389426.9
         },
         "market_cap_percentage": {
           "btc": 37.732740400955905,
           "eth": 17.8575683992539,
           "usdt": 3.7259928790065824,
           "bnb": 3.716609138245555,
           "ada": 2.2211676098033215,
           "usdc": 2.167957314167518,
           "sol": 2.086232974520336,
           "xrp": 1.7043952628242276,
           "luna": 1.3583630141420941,
           "dot": 1.2882153386311015
         },
         "market_cap_change_percentage_24h_usd": -0.45446518687163906,
         "updated_at": 1642542019
       }
     }
 
 */


// MARK: - Welcome
struct GlobalData: Codable {
    let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedwithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: {$0.key == "usd" }) {
            return "$" + item.value.formattedwithAbbreviations()
        }
        return ""
    }
    
    var bitDominance: String {
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}) {
            return item.value.asPercentString()
        }
        return ""
    }
}
