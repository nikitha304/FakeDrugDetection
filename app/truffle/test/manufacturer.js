const Manufacturer = artifacts.require("Manufacturer");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Manufacturer", function (/* accounts */) {
  it("should assert true", async function () {
    await Manufacturer.deployed();
    return assert.isTrue(true);
  });
});
