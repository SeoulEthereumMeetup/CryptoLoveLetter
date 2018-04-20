# CryptoLoveLetter
DAO powered by Aragon

# Developing
```
yarn 
npm run dev
```

###  컨셉
1. Recommendation 을 위한 투표권
CryptoLoveLetter(a.k.a. CLL) 은 각 스타 별 페이지가 만들어지고, 페이지 마다 각각 투표를 위한 투표권이 erc 토큰 형태로 생성된다.
각 스타 별로 투표권은 서로 다른 erc 토큰 형태를 띄며, 페이지 기부를 통해 발행된다. 각 스타별 투표권의 생성 관련 코드는 CryptoLoveLetter/truffle-vue/contracts/LoveTokens.sol 에 정의되어 있다.

1. The right to vote for the Recommendation
CryptoLoveLetter (a.k.a.CLL) creates a page for each star, and each page has a voting right for voting, in the form of an erc token.
Voting rights for each star are in the form of different erc tokens, issued through page donations. The code for the creation of a vote for each star is defined in CryptoLoveLetter / truffle-vue / contracts / LoveTokens.sol.

2. 커뮤니티 Governance 를 위한 Aragon.one
각 페이지 별로 커뮤니티에서 결정해야 할 이슈(페이지 매니저 임명, 레터사이즈 별 가격 등)에 대한 결정은 aragon 을 통해 결정한다.
현재 Aragon testnet 에 publish 이슈가 있어 Aragon 대시보드를 사용하지 않고 Aragon-app의 Voting App 을 포크하여 일부를 수정하여, 투표 완료 후 executionVote 를 직접 수행하였다.

2. Aragon.one for Community Governance
Decisions about issues that need to be decided by the community for each page (page manager appointment, price per letter size, etc.) are determined through aragon.
Currently, there is a publish issue in Aragon testnet, so I modified some of the Aragon-app's voting app by using Aragon-dashboard instead of using it.

Centralized Smart Contract -> Decentralized Managed & Upgradable With Aragon
# Smart Contract
https://github.com/SeoulEthereumMeetup/CryptoLoveLetter/blob/master/contracts/CryptoLoveLetter.sol
This includes managerOnly abstract Features.

https://github.com/SeoulEthereumMeetup/CryptoLoveLetter/blob/master/contracts/CryotoLoveLetterVote.sol
This is Aragon Voting App for Management.
It has only Upvote function now but it can be extendable to imple functions like Downvote and EmoticonAttribute.

# Aragon Contract
https://github.com/SeoulEthereumMeetup/CryptoLoveLetter/blob/master/contracts/LoveTokens.sol
In the Voting system, token is not used now. This is made for the future when tokenizing is needed.

https://github.com/SeoulEthereumMeetup/CryptoLoveLetter/blob/master/contracts/Voting.sol
Because of testnet publishing issue, we tried to cover this problem not to use Aragon environment. This is a trial imeplement.(Not USED)
