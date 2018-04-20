pragma solidity ^0.4.15;

contract CryptoLoveLetter {

    event SetCharacterPrice(uint price);
    event SetLetterScore(uint page_idx, uint letter_idx, uint score);
    event SetLetterAttribute(
        uint page_idx,
        uint letter_idx,
        uint key,
        uint value
    );

    event Publish(
        uint indexed page_idx,
        uint indexed letter_idx,
        address indexed owner,
        string contents
    );

    event AddPageValue(
        uint indexed idx,
        address from,
        uint value
    );

    struct Page {
        string twitterId;
        address receiver;
        uint balance;
        uint accumSupply;
        mapping (address => uint) shareOf;
    }

    struct Letter {
        address owner;
        string contents;
        uint score;
        mapping (uint => uint) attrs;
    }

    uint characterPrice;
    address public manager;

    Page[] public pages;
    mapping (uint => Letter[]) letters;

    /* Constructor */

    function CryptoLoveLetter() public {
        manager = msg.sender;
        characterPrice = 0.0001 ether;
    }

    /* Managing Features */

    function changeManager(address _manager) external managerOnly {
        manager = _manager;
    }

    function setCharacterPrice(uint _price) external managerOnly {
        characterPrice = _price;
    }

    function burnShare(uint _page_idx, address _user, uint _value)
        external
        managerOnly
    {
        uint _share = pages[_page_idx].shareOf[_user];
        require(_share >= _value);
        pages[_page_idx].shareOf[_user] -= _share;
    }

    function setLetterScore(uint _page_idx, uint _letter_idx, uint _score)
        external
        managerOnly
    {
        letters[_page_idx][_letter_idx].score = _score;
        emit SetLetterScore(_page_idx, _letter_idx, _score);
    }

    function setLetterAttribute(
        uint _page_idx,
        uint _letter_idx,
        uint _key,
        uint _value
    ) external managerOnly {
        letters[_page_idx][_letter_idx].attrs[_key] = _value;
        emit SetLetterAttribute(_page_idx, _letter_idx, _key, _value);
    }

    function setPageReceiver(uint _idx, address _receiver)
        external
        managerOnly
    {
        Page storage page = pages[_idx];
        page.receiver = _receiver;
    }

    function sendPageEther(uint _idx) external managerOnly {
        Page storage page = pages[_idx];
        require(page.receiver != manager);

        page.receiver.transfer(page.balance);
        page.balance = 0;
    }

    /* External */

    function newPage(string _twitterId) external returns (uint idx) {
        Page memory page = Page(_twitterId, manager, 0, 0);
        idx = pages.push(page);
    }

    function writeLetter(
        uint _page_idx,
        string _contents
    ) external payable returns (uint idx) {
        uint cost = bytes(_contents).length * characterPrice;
        require(cost > 0);
        require(msg.value >= cost);

        Letter memory letter = Letter(msg.sender, _contents, 1000);
        idx = letters[_page_idx].push(letter);

        emit Publish(_page_idx, idx, msg.sender, _contents);
        addPageValue(_page_idx);
    }

    /* Public */

    function addPageValue(uint _idx) public payable {
        Page storage page = pages[_idx];
        page.accumSupply += msg.value;
        page.balance += msg.value;
        pages[_idx].shareOf[msg.sender] = msg.value;

        emit AddPageValue(_idx, msg.sender, msg.value);
    }

    function getPageTwitterId(uint _index) public view returns (string) {
        return pages[_index].twitterId;
    }

    function getPagesLength() public view returns (uint) {
        return pages.length;
    }

    function getPageBalance(uint _idx) public view returns (uint) {
        return pages[_idx].balance;
    }

    function getPageAccumSupply(uint _idx) public view returns (uint) {
        return pages[_idx].accumSupply;
    }

    function getPageShareOf(address _user, uint _idx)
        public
        view
        returns (uint)
    {
        return pages[_idx].shareOf[_user];
    }

    function getLettersLength(uint _page_idx) public view returns (uint) {
        return letters[_page_idx].length;
    }

    function getLetterContents(uint _page_idx, uint _letter_idx) public view returns (string) {
        return letters[_page_idx][_letter_idx].contents;
    }

    function getLetterInfo(uint _page_idx, uint _letter_idx, uint _key)
        public
        view
        returns (address, string, uint, uint)
    {
        Letter storage _letter = letters[_page_idx][_letter_idx];

        return (
            _letter.owner,
            _letter.contents,
            _letter.score,
            _letter.attrs[_key]
        );
    }

    modifier managerOnly() {
        require(msg.sender == manager);
        _;
    }
}
