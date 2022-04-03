// Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NicMeta is ERC721Enumerable, Ownable {
    using Strings for uint256;

    bool public _isSaleActive = false; //准許合約開賣NFT
    bool public _revealed = false; //false代表抽到時為盲盒，特定時間點轉成true就能讓使用者查看自己抽到什麼NFT了

    // Constants
    uint256 public constant MAX_SUPPLY = 10; //可以被挖出來的NFT總數
    uint256 public mintPrice = 0.3 ether; //鑄造NFT的基本價錢
    uint256 public maxBalance = 1; //每個錢包地址可以擁有的NFT數量
    uint256 public maxMint = 1; //一次能挖的NFT支數

    string baseURI;
    string public notRevealedUri;
    string public baseExtension = ".json";

    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory initBaseURI, string memory initNotRevealedUri)
        ERC721("Nic Meta", "NM") //("合約名字","代號")
    {
        setBaseURI(initBaseURI);
        setNotRevealedURI(initNotRevealedUri);
    }

    //採用early return技巧所撰寫的require規則，每個require規則代表可以挖NFT的條件
    //early return need search & learn
    function mintNicMeta(uint256 tokenQuantity) public payable {
        //給用戶搶NFT用
        require( //總量限制
            totalSupply() + tokenQuantity <= MAX_SUPPLY,
            "Sale would exceed max supply"
        );
        require(_isSaleActive, "Sale must be active to mint NicMetas"); //開賣限制
        require( //持有限制
            balanceOf(msg.sender) + tokenQuantity <= maxBalance,
            "Sale would exceed max balance"
        );
        require( //確認使用者的錢包夠錢
            tokenQuantity * mintPrice <= msg.value,
            "Not enough ether sent"
        );
        require(tokenQuantity <= maxMint, "Can only mint 1 tokens at a time"); //一次能挖的數目限制

        _mintNicMeta(tokenQuantity); //以上都通過就可以call到內部function，去mint我們的nft
    }

    function _mintNicMeta(uint256 tokenQuantity) internal {
        for (uint256 i = 0; i < tokenQuantity; i++) {
            uint256 mintIndex = totalSupply();
            if (totalSupply() < MAX_SUPPLY) {
                _safeMint(msg.sender, mintIndex);
            }
        }
    }

    // 運行原理: 想像一個在區塊鏈上的資料庫，在挖NFT的時候，其實就是給user一個不會重複的數字。
    // 數字default通常是從0開始，0,1,2,3,4,5......到NFT的總量限制為止，接著建立分別對應數字的網址，對照專屬的圖片
    // 等使用者拿到數字之後，就可以拼成一個完整的往址，到他那個網址裡面就可以查看他挖到的NFT圖片
    // 舉例: 官網是 https://chieh.com/"數字".jpg (數字0~n,隨NFT發行數量而定)
    // 使用者抽到1號的話 => 就可以進到 https://chieh.com/1.jpg 查看到自己的NFT圖片
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (_revealed == false) {
            return notRevealedUri;
        }

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return
            string(abi.encodePacked(base, tokenId.toString(), baseExtension));
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    //only owner
    function flipSaleActive() public onlyOwner {
        _isSaleActive = !_isSaleActive;
    }

    function flipReveal() public onlyOwner {
        _revealed = !_revealed;
    }

    function setMintPrice(uint256 _mintPrice) public onlyOwner {
        mintPrice = _mintPrice;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function setMaxBalance(uint256 _maxBalance) public onlyOwner {
        maxBalance = _maxBalance;
    }

    function setMaxMint(uint256 _maxMint) public onlyOwner {
        maxMint = _maxMint;
    }

    function withdraw(address to) public onlyOwner {
        uint256 balance = address(this).balance;
        payable(to).transfer(balance);
    }
}
