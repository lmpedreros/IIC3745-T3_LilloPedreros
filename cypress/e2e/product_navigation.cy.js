describe('Navegación a la página de Productos', () => {
    it('Debería navegar desde la página de inicio hasta la página de Productos después de iniciar sesión', () => {
        cy.visit('http://localhost:5017');

        // Iniciar sesión
        cy.get('#navbarPrincipal').invoke('show');
        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });

        cy.contains('Iniciar Sesión').click();

        cy.fixture('seedData').then((data) => {
            const user = data.users[0];
            cy.get('input[name="user[email]"]').type(user.email);
            cy.get('input[name="user[password]"]').type(user.password);
            cy.get('input[name="commit"]').click();
        });

        // Verificar que estamos en la landing page después de iniciar sesión
        cy.url().should('include', '/');

        // Expandir el menú de navegación y hacer click en 'Productos'
        cy.get('#navbarPrincipal').invoke('show');
        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });

        cy.contains('Productos').trigger('mouseover');
        cy.contains('Ver canchas y productos').click();

        // Verificar que llegamos a la página de productos
        cy.url().should('include', '/products/index');
    });
});