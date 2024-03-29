+++
author = "ttak0422"
title = "IstioOperatorによるIstioのカスタム"
date = "2020-12-23"
categories = [
    
]
tags = [
  "CSharp",
  "MagicOnion",
  "Istio",
  "k8s"
]
+++

[広島大学ITエンジニア Advent Calendar 2020](https://adventar.org/calendars/5209) 23日目の記事になります．
[@kaito](https://twitter.com/kaito_tateyama)の[goでAPIサーバを書いた](https://www.blog.uta8a.net/posts/2020-12-20-gowiki/)に続きます！

<!--more-->

## 概要

[MagicOnion](https://github.com/Cysharp/MagicOnion)を使った簡単な(雑な)サービスを[Kubernetes](https://kubernetes.io/)上にデプロイします．
[Istio](https://github.com/istio/istio)を使ってクライアントがサービスを利用できるところまで持っていきます．
必須ではないものの[IstioOperator](https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1)を使って好きなポートを
使えるようにします．

Istioについては[公式サイト](https://istio.io/)かRedHatが公開している[Introducing Istio Service Mesh for Microservices](https://developers.redhat.com/books/introducing-istio-service-mesh-microservices/old)あたりを読んでいくとなんとなく分かると思います．

## 経緯

投稿しようと思っていた内容がmacOS Big Surで上手く動作しないというトラブルがありました．
そこで最近触り始めたIstioについて触れることにしました．
同じく最近触っているMagicOnionを連携させていきます．

Istioだからどうこうということは，ほぼ無いですがサンプルらしいサンプルも無かったので取り上げました．

## コード

今回使用したコードは以下に掲載しています．

{{< figure src="https://github-link-card.s3.ap-northeast-1.amazonaws.com/ttak0422/IstioMagicOnionSample.png" title="Screenshot" class="center" width="480" link="https://github.com/ttak0422/IstioMagicOnionSample" target="_blank" rel="noopener" >}}

### 補足説明

`README.md`と`k8s/sample-app`のmanifestを読んでもらえれば何をしているか読み取れるようになっています．
外部からのリクエストがk8sクラスタ内のGatewayを通り，VirtualServiceの内容にしたがってルーティングされ，
目当てのPodに届きます．

唯一気をつける点があるとすれば，istioのmanifestsで[定義](https://github.com/istio/istio/blob/1.7.0/manifests/charts/gateways/istio-ingress/values.yaml#L10-L27)されているように，標準で用意されているポートが，**15021**，**80**，**443**，**15443**の4つだけである点です．(Istioのバージョンに依存．今回は1.7.0を使用．)

好きなportを使いたい場合はIstioOperatorを使います．
拡張ではなく書き換えなので[コメント](https://github.com/istio/istio/blob/1.7.0/manifests/charts/gateways/istio-ingress/values.yaml#L11)
されているように,もともと定義されているportも記載しましょう．
今回は**12345**，**5432**を追加したいので以下のように定義します．

```yaml
---
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  components:
    ingressGateways:
      - name: istio-ingressgateway
        namespace: istio-system
        enabled: true
        k8s:
          service:
            ports:
            # Defaults (https://github.com/istio/istio/blob/1.7.0/manifests/charts/gateways/istio-ingress/values.yaml)
            - port: 15021
              targetPort: 15021
              name: status-port
            - port: 80
              targetPort: 8080
              name: http2
            - port: 443
              targetPort: 8443
              name: https
            - port: 15443
              targetPort: 15443
              name: tls
            # Customs
            - port: 12345
              name: grpc-magiconion
            - port: 5432
              name: http-swagger
```

```
# 定義したmanifestを反映する
$ istioctl install -f ./k8s/istio-operator/overlay.yaml
```


## その他

記載内容に間違いなどあれば[ブログ](https://github.com/ttak0422/blog)にIssueを飛ばしてください．
(ブログは2021年内に完成予定...まだタイトルも決まってない...)

最近になったIstioを実プロダクトで使っているなんて話を耳にすることが増えましたが，まだまだカスタムしたコンポーネントを使う必要があったり，
α版やβ版のApiが乱立していたりしますね...．
ですが物事をシンプルにする学習コストの高い技術が好きなので引き続き追っていきたいと思います．
これまたα版ですが[Helm](https://helm.sh/ja/)を使ったIstioOperator及びIstioの導入もありだと思います．
株式会社GRIPHONEのアドベントカレンダーの[記事](https://tech.griphone.co.jp/2020/12/12/istio-operator-101/)で分かりやすく解説されています．

はじめクライアントアプリをUnityで作ろうかと思いましたが，依然としてUnityプロジェクトをGitHubなどで共有するのが辛かったため，
CUIアプリに変更しました．MagicOnionは，Unity以外でも使うことができます．

今回初めて[Cake](https://cakebuild.net/)を使ってビルドを行ってみました．
使い勝手もよく，アドインも豊富なのでC#erにオススメできそうです．
まぁ僕は[FAKE](https://fake.build/)を使いますが...

今回は[Nix](https://nixos.org/)を意識して使わなかったですが，Kubernetesを触るようなプロジェクト・周辺ツールが乱立しているようなプロジェクトの
開発環境の構築・共有はNixが手軽だなと改めて思いました．
