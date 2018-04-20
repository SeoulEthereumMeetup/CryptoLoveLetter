pragma solidity 0.4.18;

import "@aragon/os/contracts/apps/Voting.sol";
import "./CryptoLoveLetter.sol";

contract CryptoLoveLetterVoting is Voting {

    event UpVote(uint page_idx, uint letter_idx, uint value);

    CryptoLoveLetter cryptoLoveLetter;

    function CryptoLoveLetterVoting (address _cryptoLoveLetter) {
        cryptoLoveLetter = CryptoLoveLetter(_cryptoLoveLetter);
    }

    function upVote(uint _page_idx, uint _letter_idx, uint _value) {
        uint _share = cryptoLoveLetter.getPageShareOf(msg.sender, _page_idx);
        uint _score = cryptoLoveLetter.getLetterInfo(_page_idx, _letter_idx, 0)[2];
        require(_value > 0);
        require(_share >= _value);
        uint _newScore = _score + _value;
        require(_newScore > _score);

        cryptoLoveLetter.burnShare(_page_idx, msg.sender, _value);
        cryptoLoveLetter.setLetterScore(_page_idx, _letter_idx, _newScore);

        UpVote(_page_idx, _letter_idx, _value);
    }

}
