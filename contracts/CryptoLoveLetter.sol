pragma solidity ^0.4.15;
// TEST를 위한
// CREATE 입력 변수 "0x3f5dAEe16336A7D8b58a36F8A9B12f91b3623052", "0x3f5dAEe16336A7D8b58a36F8A9B12f91b3623052"

contract CryptoLoveLetter {
    /// Buy is emitted when an letter unit is reserved.
    // 구매
    event Buy(
        uint indexed idx,
        address owner,
        uint x,
        uint y,
        uint width,
        uint height,
        uint celebrity,
        uint z_index
    );

    /// Publish is emitted whenever the contents of an letter is changed.
    // 공개
    event Publish(
        uint indexed page_idx,
        uint indexed letter_idx,
        string link,
        string title,
        bool NSFW
    );

    /// SetLetterOwner is emitted whenever the ownership of an letter is transfered
    // 소유자 정하기
    event SetLetterOwner(
        uint indexed page_idx,
        uint indexed letter_idx,
        address from,
        address to
    );

    // 소유자 정하기
    event SetPageOwner(
        uint indexed idx,
        address from,
        address to
    );

    // Z-Index당 최소금액정하기
    uint public constant weiZIndexPrice = 1000000000000000;

    /// Price is 1 kether divided by 1,000,000 pixels
    // 최소금액정하기
    uint public constant weiPixelPrice = 1000000000000000;

    /// Each grid cell represents 100 pixels (10x10).
    // 기준 그리드 픽셀단위
    uint public constant pixelsPerCell = 100;

    // 새로운 페이지 만드는데 필요한 Wei
    uint weiNewPagePrice;

    /// contractOwner can withdraw the funds and override NSFW status of letter units.
    // 계약소유자
    address contractOwner;

    /// withdrawWallet is the fixed destination of funds to withdraw. It is
    /// separate from contractOwner to allow for a cold storage destination.
    // 출금 지갑
    address withdrawWallet;

    // Page 편지지 = 연예인 페이지
    struct Page {
      address owner;
      string twitterId;
      /// ages and workplaces.
      bool NSFW;
      /// forceNSFW can be set by owner.
      bool forceNSFW;
    }

    // Letter 편지
    struct Letter {
        address owner;
        uint x;
        uint y;
        uint width;
        uint height;
        uint color;
        string nickname;
        string contents;
        string link;
        /// NSFW is whether the letter is suitable for people of all
        /// ages and workplaces.
        bool NSFW;
        /// forceNSFW can be set by owner.
        bool forceNSFW;
    }

    modifier ownerOnly()
    {
        require(msg.sender == contractOwner);
        _;
    }

    // 모든 편지지=연예인 페이지 들 주소
    Page[] public pages;
    mapping (string => uint) pagesMap;
    mapping (uint => Letter[]) letters;

    // 생성자 소유자, 지갑
    function CryptoLoveLetter(address _contractOwner, address _withdrawWallet) {
        require(_contractOwner != address(0));
        require(_withdrawWallet != address(0));

        contractOwner = _contractOwner;
        withdrawWallet = _withdrawWallet;
    }

    /// getLettersLength tells you how many letters  there are
    // 최대 보내진 편지 수량 가져오기
    function getLettersLength(uint _page_idx) constant returns (uint) {
        return letters[_page_idx].length;
    }

    // 최대 보내진 편지 수량 가져오기
    function getPageLength() constant returns (uint) {
        return pages.length;
    }

    // Page id => 이름 가져오기
    function getPageTwitterId(uint _index) constant returns (string) {
        return pages[_index].twitterId;
    }

    // 새로운 연예인 추가 하기
    function newPage(string _twitterId) payable public returns (uint idx) {
      if (pagesMap[_twitterId] != 0) revert();
      Page memory page = Page(msg.sender, _twitterId, false, false);
      idx = pages.push(page);
      pagesMap[_twitterId] = idx;
      return idx;
    }

    /// Letters must be purchased in 10x10 pixel blocks.
    /// Each coordinate represents 10 pixels. That is,
    ///   _x=5, _y=10, _width=3, _height=3
    /// Represents a 30x30 pixel letter at coordinates (50, 100)
    // 편지 보내기 Copying of type struct CryptoLoveLetter.Letter memory[] memory to storage not yet supported.
    // TODO: 셀레브리티을 기준으로 계산하는것을 만든다.
    function buy(uint _x, uint _y, uint _width, uint _height
        , uint _page_idx
        , uint _color
        , string _nickname
        , string _contents
        , string _link
        ) payable returns (uint idx) {

        uint cost = _width * _height * pixelsPerCell * weiPixelPrice;
        require(cost > 0);
        require(msg.value >= cost);

        Letter memory letter = Letter(msg.sender, _x, _y, _width, _height, _color, _nickname, _contents, _link, false, false);
        idx = letters[_page_idx].push(letter);
        Buy(idx, msg.sender, _x, _y, _width, _height, _page_idx, 1);
        return idx;
    }

    // 연예인 편지지 페이지의 소유권을 설정한다.
    function setPageOwner(uint _idx, address _newOwner) {
        Page storage page = pages[ _idx];
        require(msg.sender == page.owner);
        page.owner = _newOwner;

        SetPageOwner(_idx, msg.sender, _newOwner);
    }

    /// setLetterOwner changes the owner of an letter unit
    // 편지의 소유권을 설정한다.
    function setLetterOwner(uint _page_idx, uint _letter_idx, address _newOwner) {
        Letter storage letter = letters[_page_idx][ _letter_idx];
        require(msg.sender == letter.owner);
        letter.owner = _newOwner;

        SetLetterOwner(_page_idx, _letter_idx, msg.sender, _newOwner);
    }

    /// forceNSFW allows the owner to override the NSFW status for a specific letter unit.
    // override기능!
    function forceNSFW(uint _page_idx, uint _letter_idx, bool _NSFW) ownerOnly {
        Letter storage letter = letters[_page_idx][_letter_idx];
        letter. forceNSFW = _NSFW;

        Publish(_page_idx, _letter_idx, letter.link, letter.nickname, letter.NSFW || letter.forceNSFW);
    }

    /// withdraw allows the owner to transfer out the balance of the contract.
    // 출금
    function withdraw() ownerOnly {
        withdrawWallet.transfer(this.balance);
    }
}
