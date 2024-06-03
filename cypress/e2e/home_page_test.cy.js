describe('Test home page', function() {

  it('check landing page', function() {
    cy.visit('/')
    cy.contains('Ejercita. Juega. Disfruta.')
  })

})
