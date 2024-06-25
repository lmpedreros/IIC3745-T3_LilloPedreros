const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl: "http://host.docker.internal:5017",
    defaultCommandTimeout: 10000,
    supportFile: "cypress/support/index.js",
    specPattern: "cypress/e2e/**/*.cy.{js,jsx,ts,tsx}"
  }
})
