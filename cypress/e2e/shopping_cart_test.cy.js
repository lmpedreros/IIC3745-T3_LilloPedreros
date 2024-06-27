// ESTE TEST SOLO FUNCIONA SI SE USA UN USUARIO DE LA SEED QUE YA HA SIDO CREADO EN LA PÁGINA.

describe('Navegación a "Mi carrito" con usuario ya creado.', () => {
    it('Debería navegar desde la página de inicio hasta la página "Mi carrito" con un usuario YA creado', () => {
        cy.visit('http://localhost:5017'); // cy.visit es para visitar la página... o algo así

        // Expandimos el menú de navegación (es un pequeño hack.... shhhh.)
        cy.get('#navbarPrincipal').invoke('show');
        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });

        // Hacemos click en Iniciar sesión
        cy.contains('Iniciar Sesión').click();

        // Ingresamos las credenciales (en este caso las del usuario X) e iniciamos sesión
        cy.fixture('seedData').then((data) => {
            const user = data.users[4];
            cy.get('input[name="user[email]"]').type(user.email);
            cy.get('input[name="user[password]"]').type(user.password);
            cy.get('input[name="commit"]').click();
        });

        // Expandimos el menú de navegación (es un pequeño hack.... shhhh.)
        cy.get('#navbarPrincipal').invoke('show');
        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });

        // Hacemos click en 'Mi carrito'
        cy.contains('Mi carrito').click();
        cy.url().then((url) => {
            cy.log('URL actual:', url);
        });

        // Verificamos que llegamos a la nueva página con el nuevo URL
        cy.url().should('include', '/carro');
    });
});