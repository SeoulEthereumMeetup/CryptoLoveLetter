# CryptoLoveLetter
DAO powered by Aragon

# loveletterblock
loveletterblock.io

###  개발하기
```
cd truffle-vue
npm install
brew install cairo  # fabricjs 을 이용하기 위해 https://github.com/kangax/fabric.js/
npm run dev
```

###  컨셉
1. Recommendation 을 위한 투표권
CryptoLoveLetter(a.k.a. CLL) 은 각 스타 별 페이지가 만들어지고, 페이지 마다 각각 투표를 위한 투표권이 erc 토큰 형태로 생성된다.
각 스타 별로 투표권은 서로 다른 erc 토큰 형태를 띄며, 페이지 기부를 통해 발행된다. 각 스타별 투표권의 생성 관련 코드는 CryptoLoveLetter/truffle-vue/contracts/LoveTokens.sol 에 정의되어 있다.

2. 커뮤니티 Governance 를 위한 Aragon.one
각 페이지 별로 커뮤니티에서 결정해야 할 이슈(페이지 매니저 임명, 레터사이즈 별 가격 등)에 대한 결정은 aragon 을 통해 결정한다.
현재 Aragon testnet 에 publish 이슈가 있어 Aragon 대시보드를 사용하지 않고 Aragon-app의 Voting App 을 포크하여 일부를 수정하여, 투표 완료 후 executionVote 를 직접 수행하였다.
