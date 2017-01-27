Test with MagicHash
====

# About the motivation of optimization

先に注意しておく。Knuth先生もおっしゃっているようにこんなところを最適化するのではなくてちゃんと最適化する甲斐のある部分を最適化すべきである。
私は単に興味が出たからするだけだから、これに値しない。

また簡単なMagicHashの使いところが出てきたので試してみた。
Bench/MagicHash にcriterionのベンチマーク実験をまとめて見た。

`length`のような関数ならばこのような最適化に疑いを持たないだろうが、今回は違う。
`testBit`の引数としてそのaccumulatorを与えないといけない。
そのためにunlifted valueを一度`I# value`の形でまとめる作業が必要だ。
最適化することでこの無駄な作業はなくなると信じたいけれど。

試行回数を変えてみてもそもそも変わらない。違いは全部誤差の範囲内である。
問題は最適化した部分よりリストの作成の方がより多くの計算量を持っていかれているのかもしれない。

````
decodeFlagO :: Int -> [X]
decodeFlagO = decodeFlagOSub (bitLen-1)
decodeFlagOSub (-1) aFlag = []
decodeFlagOSub num aFlag =
  if testBit aFlag num
    then toEnum num : decodeFlagOSub (num-1) aFlag
    else              decodeFlagOSub (num-1) aFlag


decodeFlagMH :: Int -> [X]
decodeFlagMH aFlag = decodeFlagMHSub (bitLen# -# 1#)
  where
    !(I# bitLen#) = bitLen
    decodeFlagMHSub (-1#) = []
    decodeFlagMHSub idx# =
      if testBit aFlag (I# idx#)
        then toEnum (I# idx#) : decodeFlagMHSub (idx# -# 1#)
        else                    decodeFlagMHSub (idx# -# 1#)

decodeFlagT :: Int -> [X]
decodeFlagT aFlag = decodeFlagTSub (bitLen-1)
  where
    decodeFlagTSub (-1) = []
    decodeFlagTSub num =
      if testBit aFlag num
        then toEnum num : decodeFlagTSub (num-1)
        else              decodeFlagTSub (num-1)
````

ならば、実験のためにリスト作成ではなく足し算くらいに変えてみよう。

````
decodeFlagO :: Int -> Int
decodeFlagO aFlag = I# (decodeFlagOSub (bitLen-1) 0# aFlag)
decodeFlagOSub (-1) acc# aFlag = acc#
decodeFlagOSub num  acc# aFlag =
  if testBit aFlag num
    then decodeFlagOSub (num-1) (acc#+#1#) aFlag
    else decodeFlagOSub (num-1)  acc#      aFlag


decodeFlagMH :: Int -> Int
decodeFlagMH aFlag = I# (decodeFlagMHSub (bitLen# -# 1#) 0#)
  where
    !(I# bitLen#) = bitLen
    decodeFlagMHSub (-1#) acc# = acc#
    decodeFlagMHSub idx#  acc# =
      if testBit aFlag (I# idx#)
        then decodeFlagMHSub (idx# -# 1#) (acc#+#1#)
        else decodeFlagMHSub (idx# -# 1#)  acc#

decodeFlagT :: Int -> Int
decodeFlagT aFlag = I# (decodeFlagTSub (bitLen-1) 0#)
  where
    decodeFlagTSub (-1) acc# = acc#
    decodeFlagTSub num acc# =
      if testBit aFlag num
        then decodeFlagTSub (num-1) (acc#+#1#)
        else decodeFlagTSub (num-1)  acc#
````

結果として、予想通り安定してdecodeFlagMHが早い結果を得られた。
が、その差があまりにも小さく、この結果を信じて良いものか自分でも確かではない。
まあ、価値が無いわけではないのだが、依存性問題が増えるので好ましくはない。
とはいえ、新しくインストールするようなものではない。`ghc-prim`なら誰も持っていそうなものである。