const Migrations = artifacts.require("Migrations");
const Guigui = artifacts.require("Guigui");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Guigui, "guigui", "GG");
};
