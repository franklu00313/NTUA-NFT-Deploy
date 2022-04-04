# NFT ERC-721 Basic Example

# Nick 流程

- 大綱

#

##

###

# 參考影片

[NFT 智能合約開發全攻略! 發行 NFT 背後的技術實戰及原理! 盲盒、公開發售怎麼做到的? | 在地上滾的工程師 Nic](https://www.youtube.com/watch?v=3vWw9Xt48bs&ab_channel=%E5%9C%A8%E5%9C%B0%E4%B8%8A%E6%BB%BE%E7%9A%84%E5%B7%A5%E7%A8%8B%E5%B8%ABNic)

# MetaMask 小狐狸錢包

## Introduction

<aside>
💡 若說幣安是中心化的銀行，小狐狸就是隨身的錢包。銀行倒了錢會不見，錢包只要不外流助憶詞，就永遠是自己的私有財產。

</aside>

- 錢包本身沒啥用，但卻是**使用其他去中心化服務的媒介!**
- 助憶詞(Secret Recovery Phrase) : 如同私鑰，決定錢包歸屬權的唯一東西，絕對不能外洩，要好好的保存起來，如果忘了等於裡面的錢都拿不出來了!

## Step

1. 下載 google chrome extension : MetaMask
2. 開一個小狐狸錢包 (若忘記可到以下連結複習)

   [MetaMask 小狐狸錢包教學：如何使用、下載、從幣安轉帳進去？ - 蘋果仁 - 果仁 iPhone/iOS/好物推薦科技媒體](https://applealmond.com/posts/128352)

3. 設定 > 進階 > Show test network 開啟，轉換成 Rinkeby 測試網路
4. 到以下網址領取至少 0.4 虛擬 ETH (每次可領取 0.1ETH，重複 4 次)

   [Faucets | Chainlink](https://faucets.chain.link/rinkeby)

# 開發 ETH 的智能合約

## Step

1. 直接使用官方的線上編輯器 Remix

   [Remix - Ethereum IDE](https://remix.ethereum.org/)

2. 用 GitHub 的管道把 Nick 提供的 GitHub 網址讀進來

   [nic_meta/nic_meta_nft.sol at master · niclin/nic_meta](https://github.com/niclin/nic_meta/blob/master/contracts/nic_meta_nft.sol)

   註 : 有加一些 comment 然後 push 上去了(沒動到程式本體)

3. Compile 看看，確定合約沒有撰寫錯誤，同時將程式碼編譯成 bytecode 準備送上鏈
4. 選第三個按鈕
   - 環境選擇 Injected Web3
   - Contract 下拉選單，選到我們剛剛編譯好的那個
   - 按下 deploy 按鈕
   - 稍等一下，好了下面會出現佈署好的合約以供互動(一堆 button)
5. 用 Remix 購買 NFT
   - 點選 flipSaleActive ⇒ 將 NFT 販售權限打開
   - 到 VALUE 部分填入價格，因為不能填入小數點 ⇒ 到以下轉換單位為 Gwei
     [Ethereum Unit Converter](https://eth-converter.com/)
   - 到 mintNicMeta 輸入數量 1，按下 transact 進行 mint
6. 去 Opensea 的測試網站查看是否有收到 NFT

   [](https://testnets.opensea.io/)

7. 若找到以下 NFT 即代表大功告成 !

   ![Untitled](Nick%20%E6%B5%81%E7%A8%8B%20fc3eb/Untitled.png)

# 上傳拼圖

## Step

1. 先到 GitHub 上面把專案 clone 下來

   [https://github.com/HashLips/hashlips_art_engine](https://github.com/HashLips/hashlips_art_engine)

2. 打開 src/main.js 的 343 行修改 code，原因是設定的 ETH 起始數字和 Solana(SOL)不一樣，但 Nick 表示一樣的話會比較好開發。

   ```cpp
   //old
   let i = network == NETWORK.sol ? 0 : 1;
   //new
   let i = 0;
   ```

3. 到 src/config.js，改動產生圖片數量從 5 張變 10 張 (line:24)

   ```cpp
   const layerConfigurations = [
     {
       growEditionSizeTo: 10,//5,
       layersOrder: [
         { name: "Background" },
         { name: "Eyeball" },
         { name: "Eye color" },
         { name: "Iris" },
         { name: "Shine" },
         { name: "Bottom lid" },
         { name: "Top lid" },
       ],
     },
   ];
   ```

4. 建立圖片
   - 確認是否有下載 yarn package
     ```cpp
     // check version
     yarn --version

     //if not installed then install
     npm install --global yarn
     ```
   - 產生圖片
     ```cpp
     //在node_modules目錄安裝package.json中列出的所有依賴
     //第一次需要(吧?
     yarn install

     //產生圖片
     yarn run build
     ```
   - 在 build 裡面即可看到，image 資料夾存放圖片，json 裡面存放 metadata，代表眼睛的參數(NFT 屬性)，讓使用者可以在 opensea 上面看到。
5. Pinata
   - 是一種 IPFS(星際文件系統)
     - IPFS Intro Ref(還沒看，但感覺像是去中心化的 http 協議，用區塊鏈儲存檔案) :
       [【IPFS 技術佈道人】入門淺談：什麼是 IPFS？ - 區塊客](https://blockcast.it/2019/10/16/let-me-tell-you-what-is-ipfs/)
   - 註冊 Pinata
   - Upload 剛剛那十張照片的 folder，copy 該 CID
   - 到 config.js 裡面，用 CID 取代原本的 baseUri
     ```cpp
     //old
     const baseUri = "ipfs://NewUriToReplace";
     //new
     const baseUri = "ipfs://QmYQzUs9R1SuHRJfxJnh8GNmL9WdHvZLjywwcJvEju8XC6";
     ```
   - 跑指令，更新每個 metadata 的資料
     ```cpp
     yarn run update_info
     ```
   - 到圖片的 js 檔案裏面，檢查 image 是否有替換成我們 CID
     ```json
     {
       "name": "Your Collection #2",
       "description": "Remember to replace this description",
       "image": "ipfs://QmYQzUs9R1SuHRJfxJnh8GNmL9WdHvZLjywwcJvEju8XC6/2.png",
       "dna": "0de3c8add53f3a8fd2c6a653dad9f3a646255121",
     ```
   - 回 Pinata 上傳整包 json 資料夾
   - 製作盲盒
     - 在 hashlip project 下面再開一個資料夾，裝盲盒的圖片檔&json 檔
       - 圖片檔:上傳 file 到 Pinata，拿到 CID
       - JSON 檔案: 設定盲盒的基本資訊，CID 填到 image 的欄位
         ```json
         {
           "name": "Chieh's BlindBox",
           "description": "Testing BlindBox",
           "image": "ipfs://QmeMXChGoiaMHQd9bWbCwvZzKVJUVsP22p8XXss7F239tU"
         }
         ```
       - 將 JSON 檔案也上傳到 Pinata 上
6. 回到 Remix
   - setNotRevealedURI : 填上"ipfs://” + 盲盒 JSON 的 CID，transact
   - setBaseURI : 填上"ipfs://” + META_JSONS(十張 NFT 圖片的 folder)的 CID + **"/”**
     - 最後的斜線要記得加，因為圖片是用拼起來的
7. 去 Opensea 確認是否有改變成盲盒的樣子(五分內會變)
8. 回 Remix 按 flipReveall 按鈕，再回去 Opensea 確認應該可以看到 NFT 的樣式了，大功告成!

# 補充 : 如何重新打開已佈署的合約

### Reference

[Deploy & Run - Remix - Ethereum IDE 1 documentation](https://remix-ide.readthedocs.io/en/latest/run.html#using-the-abi-with-ataddress)

<aside>
💡 **ABI 是一個JSON array，用以描述contract’s interface。**

</aside>

## Step

1. 將 sol 檔案重新 compile 過之後，copy ABI 代碼 (contract 種類要記得換)
2. 建立一個.abs 檔案，把剛剛複製的代碼丟進去 ⇒ 但沒用這步好像也有辦法(?
3. 到 deploy 區域，在 At Address 輸入合約的(0x5E44962F97b1d5378Cb91C8a37DF9e58C771C193)
   - 不太確定合約地址怎麼找，已知兩方法:
     - 第一次佈署的時候直接記下來
       ![Untitled](Nick%20%E6%B5%81%E7%A8%8B%20fc3eb/Untitled%201.png)
     - 去小狐狸錢包的交易紀錄翻找 (但如果不止一個合約 or 交易頻繁就會很難找)
     - **Update : 小狐狸 ⇒ etherscan ⇒ view contract creation 可以找到所有帳號創造的合約**
       ![Untitled](Nick%20%E6%B5%81%E7%A8%8B%20fc3eb/Untitled%202.png)
4. 點擊 At Address 就可以操作合約了
