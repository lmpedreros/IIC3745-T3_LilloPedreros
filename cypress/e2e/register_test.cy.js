// ESTE TEST SOLO FUNCIONA SI SE USA UN USUARIO NUEVO DE LA SEED.

describe('Navegación a la creación de usuario', () => {
    it('Debería poder crear un usuario NUEVO y volver a la página de inicio', () => {
        cy.visit('http://localhost:5017'); // cy.visit es para visitar la página... o algo así

        // Expandimos el menú de navegación (es un pequeño hack.... shhhh.)
        cy.get('#navbarPrincipal').invoke('show');
        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });

        // Hacemos click en Regístrarte
        cy.contains('Regístrate').should('be.visible').click();
        cy.url().should('include', '/register');

        // Ingresamos las credenciales (en este caso las del usuario Y) e iniciamos sesión
        cy.fixture('seedData').then((data) => {
            const user = data.users[4];
            cy.get('input[name="user[email]"]').type(user.email);
            cy.get('input[name="user[name]"]').type(user.name);
            cy.get('input[name="user[password]"]').type(user.password);
            cy.get('input[name="user[password_confirmation]"]').type(user.password);
            cy.get('input[name="commit"]').click();
        });
        cy.url().should('not.include', '/register');

        // Expandimos el menú de navegación (es un pequeño hack.... shhhh.)
        cy.get('#navbarPrincipal').invoke('show');
        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });

        // Hacemos click en 'Mi cuenta'
        cy.contains('Mi cuenta').should('be.visible').click();

        // Verificamos que llegamos a la nueva página con el nuevo URL
        cy.url().should('include', '/users/show');
    });
});