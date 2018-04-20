pragma solidity ^0.4.15;

contract KetherHomepage {
    /// Buy is emitted when an ad unit is reserved.
    // 구매
    event Buy(
        uint indexed idx,
        address owner,
        uint x,
        uint y,
        uint width,
        uint height
    );

    /// Publish is emitted whenever the contents of an ad is changed.
    // 공개
    event Publish(
        uint indexed idx,
        string link,
        string image,
        string title,
        bool NSFW
    );

    /// SetAdOwner is emitted whenever the ownership of an ad is transfered
    // 소유자 정하기
    event SetAdOwner(
        uint indexed idx,
        address from,
        address to
    );

    /// Price is 1 kether divided by 1,000,000 pixels
    // 최소금액정하기
    uint public constant weiPixelPrice = 1000000000000000;

    /// Each grid cell represents 100 pixels (10x10).
    // 기준 그리드 픽셀단위
    uint public constant pixelsPerCell = 100;

    // 기준 그리드= 편지 전체 크기
    bool[100][100] public grid;

    /// contractOwner can withdraw the funds and override NSFW status of ad units.
    // 계약소유자
    address contractOwner;

    /// withdrawWallet is the fixed destination of funds to withdraw. It is
    /// separate from contractOwner to allow for a cold storage destination.
    // 출금 지갑
    address withdrawWallet;

    // Letter 편지
    struct Ad {
        address owner;
        uint x;
        uint y;
        uint width;
        uint height;
        string link;
        string image;
        string title;
        // 추가 글씨 색 선택하기
        string color;
        // 추가 본문
        string message;
        // 추가 연예인( 유명인 기준으로 묶어서도 보여주고 payable의 중복의 기준이 된다.)
        string celebrity;

        /// NSFW is whether the ad is suitable for people of all
        /// ages and workplaces.
        bool NSFW;
        /// forceNSFW can be set by owner.
        bool forceNSFW;
    }

    /// ads are stored in an array, the id of an ad is its index in this array.
    // 모든 편지들 주소
    Ad[] public ads;

    // 생성자 소유자, 지갑
    function KetherHomepage(address _contractOwner, address _withdrawWallet) {
        require(_contractOwner != address(0));
        require(_withdrawWallet != address(0));

        contractOwner = _contractOwner;
        withdrawWallet = _withdrawWallet;
    }

    /// getAdsLength tells you how many ads there are
    // 최대 보내진 편지 수량 가져오기
    function getAdsLength() constant returns (uint) {
        return ads.length;
    }

    /// Ads must be purchased in 10x10 pixel blocks.
    /// Each coordinate represents 10 pixels. That is,
    ///   _x=5, _y=10, _width=3, _height=3
    /// Represents a 30x30 pixel ad at coordinates (50, 100)
    // 편지 보내기
    // TODO: 셀레브리티을 기준으로 계산하는것을 만든다.
    function buy(uint _x, uint _y, uint _width, uint _height) payable returns (uint idx) {
        uint cost = _width * _height * pixelsPerCell * weiPixelPrice;
        require(cost > 0);
        require(msg.value >= cost);

        // Loop over relevant grid entries
        for(uint i=0; i<_width; i++) {
            for(uint j=0; j<_height; j++) {
                if (grid[_x+i][_y+j]) {
                    // Already taken, undo.
                    revert();
                }
                grid[_x+i][_y+j] = true;
            }
        }

        // We reserved space in the grid, now make a placeholder entry.
        Ad memory ad = Ad(msg.sender, _x, _y, _width, _height, "", "", "", false, false);
        idx = ads.push(ad) - 1;
        Buy(idx, msg.sender, _x, _y, _width, _height);
        return idx;
    }

    /// Publish allows for setting the link, image, and NSFW status for the ad
    /// unit that is identified by the idx which was returned during the buy step.
    /// The link and image must be full web3-recognizeable URLs, such as:
    ///  - bzz://a5c10851ef054c268a2438f10a21f6efe3dc3dcdcc2ea0e6a1a7a38bf8c91e23
    ///  - bzz://mydomain.eth/ad.png
    ///  - https://cdn.mydomain.com/ad.png
    /// Images should be valid PNG.
    // 공개핸다.
    function publish(uint _idx, string _link, string _image, string _title, bool _NSFW) {
        Ad storage ad = ads[_idx];
        require(msg.sender == ad.owner);
        ad.link = _link;
        ad.image = _image;
        ad.title = _title;
        ad.NSFW = _NSFW;

        Publish(_idx, ad.link, ad.image, ad.title, ad.NSFW || ad.forceNSFW);
    }

    /// setAdOwner changes the owner of an ad unit
    // 소유권을 설정한다.
    function setAdOwner(uint _idx, address _newOwner) {
        Ad storage ad = ads[_idx];
        require(msg.sender == ad.owner);
        ad.owner = _newOwner;

        SetAdOwner(_idx, msg.sender, _newOwner);
    }

    /// forceNSFW allows the owner to override the NSFW status for a specific ad unit.
    // override기능!
    function forceNSFW(uint _idx, bool _NSFW) {
        require(msg.sender == contractOwner);
        Ad storage ad = ads[_idx];
        ad.forceNSFW = _NSFW;

        Publish(_idx, ad.link, ad.image, ad.title, ad.NSFW || ad.forceNSFW);
    }

    /// withdraw allows the owner to transfer out the balance of the contract.
    // 출금
    function withdraw() {
        require(msg.sender == contractOwner);
        withdrawWallet.transfer(this.balance);
    }
}
