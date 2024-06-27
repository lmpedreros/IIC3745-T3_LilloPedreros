// Happy Path
describe('Formulario de Creación de Producto - Happy Path.', () => {
    it('Permitir crear un producto con datos válidos', () => {
        cy.visit('http://localhost:5017');

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
            const user = data.users[0];
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
        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });
        cy.get('hr.navbar-divider.has-background-info-light').then(($divider) => {
            if ($divider.is(':visible')) {
                // Realizar alguna acción si el divisor es visible
                cy.wrap($divider).should('be.visible'); // Aseguramos que el divisor sea visible
            }
        });

        cy.contains('Crear producto').click();
        cy.url().then((url) => {
            cy.log('URL actual:', url);
        });
        cy.url().should('include', '/products/crear');

        // ======================================================================================================================================

        cy.fixture('seedData').then((data) => {
            const product = data.products[0];
            cy.get('input[name="product[nombre]"]').type(product.nombre);
            cy.get('select[name="product[categories]"]').should('be.visible').select('Equipamiento');
            cy.get('input[name="product[precio]"]').type(product.precio);
            cy.get('input[name="product[stock]"]').type(product.stock);
            cy.get('button').contains('Guardar').should('be.visible').click();
        });

        cy.url().should('include', '/products/index');
    });
});

// Camino alternativo 1
describe('Formulario de Creación de Producto - Camino Alternativo 1', () => {
    it('No permitir crear un producto sin nombre', () => {
        cy.visit('http://localhost:5017');

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

        cy.get('#navbarPrincipal').invoke('show');
        cy.get('#navbarPrincipal.navbar-menu').invoke('show');

        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });
        cy.get('#navbarPrincipal.navbar-menu').invoke('show');
        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });
        cy.get('hr.navbar-divider.has-background-info-light').then(($divider) => {
            if ($divider.is(':visible')) {
                // Realizar alguna acción si el divisor es visible
                cy.wrap($divider).should('be.visible'); // Aseguramos que el divisor sea visible
            }
        });

        // Navegamos a la página de creación de productos
        cy.contains('Crear producto').click();
        cy.url().should('include', '/products/crear');

        // Llenar el formulario sin el nombre del producto
        cy.fixture('seedData').then((data) => {
            const product = data.products[0];
            cy.get('select[name="product[categories]"]').select('Equipamiento');
            cy.get('input[name="product[precio]"]').type(product.precio);
            cy.get('input[name="product[stock]"]').type(product.stock);

            cy.get('input[name="product[nombre]"]').then(($input) => {
                $input[0].checkValidity();
                const validationMessage = $input[0].validationMessage;
                expect(validationMessage).to.be.oneOf(['Rellene este campo.', 'Please fill out this field.']);
            });
        });
    });
});


// Camino alternativo 2
describe('Formulario de Creación de Producto - Camino Alternativo 2', () => {
    it('No permitir crear un producto con precio inválido', () => {
        cy.visit('http://localhost:5017');

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

        cy.get('#navbarPrincipal').invoke('show');
        cy.get('#navbarPrincipal.navbar-menu').invoke('show');

        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });
        cy.get('#navbarPrincipal.navbar-menu').invoke('show');
        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });
        cy.get('hr.navbar-divider.has-background-info-light').then(($divider) => {
            if ($divider.is(':visible')) {
                // Realizar alguna acción si el divisor es visible
                cy.wrap($divider).should('be.visible'); // Aseguramos que el divisor sea visible
            }
        });

        // Navegamos a la página de creación de productos
        cy.contains('Crear producto').click();
        cy.url().should('include', '/products/crear');

        // Llenamos el formulario mal
        cy.fixture('seedData').then((data) => {
            const product = data.products[0];
            cy.get('input[name="product[nombre]"]').type(product.nombre);
            cy.get('select[name="product[categories]"]').select('Equipamiento');
            cy.get('input[name="product[precio]"]').type("mamase mamasa mamacusa");
            cy.get('input[name="product[stock]"]').type(product.stock);
            cy.get('button').contains('Guardar').click();
        });

        // Verificamos que se muestre el mensaje de error
        cy.contains('Hubo un error al guardar el producto: Precio: no es un número').should('be.visible');
    });
});


// Camino alternativo 3
describe('Formulario de Creación de Producto - Camino Alternativo 3', () => {
    it('No permitir crear un producto con stock inválido', () => {
        cy.visit('http://localhost:5017');

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

        cy.get('#navbarPrincipal').invoke('show');
        cy.get('#navbarPrincipal.navbar-menu').invoke('show');

        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });
        cy.get('#navbarPrincipal.navbar-menu').invoke('show');
        cy.get('.navbar-burger').then(($burger) => {
            if ($burger.is(':visible')) {
                cy.wrap($burger).click();
            }
        });
        cy.get('hr.navbar-divider.has-background-info-light').then(($divider) => {
            if ($divider.is(':visible')) {
                // Realizar alguna acción si el divisor es visible
                cy.wrap($divider).should('be.visible'); // Aseguramos que el divisor sea visible
            }
        });

        // Navegamos a la página de creación de productos
        cy.contains('Crear producto').click();
        cy.url().should('include', '/products/crear');

        // Llenar el formulario mal
        cy.fixture('seedData').then((data) => {
            const product = data.products[0];
            cy.get('input[name="product[nombre]"]').type(product.nombre);
            cy.get('select[name="product[categories]"]').select('Equipamiento');
            cy.get('input[name="product[precio]"]').type(product.precio);
            cy.get('input[name="product[stock]"]').type("stock");
            cy.get('button').contains('Guardar').click();
        });

        // Verificar que se muestre el mensaje de error
        cy.contains('Hubo un error al guardar el producto: Stock: no es un número').should('be.visible');
    });
});
