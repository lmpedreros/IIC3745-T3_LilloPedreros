// Happy Path
describe('Formulario de Creación de Producto - Happy Path', () => {
    it('Permitir crear un producto con datos válidos', () => {
        // Visitar la página de creación de productos
        cy.visit('/');

        // Verificar que se haya cargado la página correctamente
        cy.url().should('include', '/'); // Verifica que la URL contenga '/'

        // ======================================================================================================================================
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
            const user = data.users[6];
            cy.get('input[name="user[email]"]').type(user.email);
            cy.get('input[name="user[password]"]').type(user.password);
            cy.get('input[name="commit"]').click();
        });
        // ======================================================================================================================================

        cy.get('#navbarPrincipal').invoke('show');
        cy.get('#navbarPrincipal.navbar-menu').invoke('show');

        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });
        cy.get('#navbarPrincipal.navbar-menu').invoke('show');

        // Verificar que el botón "Crear producto" esté visible y hacer clic en él
        cy.get('.navbar-item.has-dropdown.is-hoverable') // Selecciona el elemento que contiene el botón
            .contains('Productos') // Encuentra el enlace que contiene 'Productos'
            .click();

        // Esperar a que aparezca el menú desplegable y hacer clic en "Crear producto"
        cy.get('.navbar-dropdown.is-left') // Selecciona el menú desplegable
            .contains('Crear producto') // Encuentra el enlace que contiene 'Crear producto'
            .click();

        // Verificar que la URL haya cambiado a la página de creación de producto
        cy.url().should('include', '/products/crear'); // Verifica que la URL contenga '/products/crear'

        // Llenar el formulario con datos válidos
        // cy.get('input[name="product[nombre]"]').type('Raqueta de Tenis');
        // cy.get('input[name="product[descripcion]"]').type('Raqueta de tenis de alta calidad.');
        // cy.get('input[name="product[precio]"]').type('100');
        // cy.get('input[name="product[stock]"]').type('50');

        // // Enviar el formulario
        // cy.get('input[name="commit"]').click();

        // // Verificar que el producto se ha creado correctamente
        // cy.contains('Producto creado exitosamente').should('be.visible');
        // cy.url().should('include', '/products/show');
    });
});

// Camino alternativo 1

// Camino alternativo 2

// Camino alternativo 3