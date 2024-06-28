// Happy Path
describe('Formulario de envio de mensaje - Happy Path.', () => {
    it('Permitir crear un mensaje con datos válidos', () => {
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

        // Navegamos a la página de un producto
        cy.fixture('seedData').then((data) => {
            const product = data.products[2];
            cy.visit(`/products/leer/${product.id}`);
        });

        // Llenamos el formulario de mensaje y lo enviamos
        cy.fixture('seedData').then((data) => {
            const messageBody = "Hola, estoy interesado en tu producto.";
            cy.get('input[name="message[body]"]').type(messageBody);
            cy.get('button').contains('Crear').click();
        });

        // Verificamos que el mensaje se haya enviado correctamente
        cy.contains('Tu mensaje ha sido enviado con éxito').should('be.visible');
    });

    it('No permitir enviar un mensaje sin cuerpo', () => {
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

        // Navegamos a la página de un producto
        cy.fixture('seedData').then((data) => {
            const product = data.products[0];
            cy.visit(`/products/leer/${product.id}`);
        });

        // Intentar enviar un mensaje vacío
        cy.get('button').contains('Crear').click();

        // Verificar que se muestra el mensaje de error
        cy.contains('No puedes enviar un mensaje vacío').should('be.visible');
    });

    it('No permitir enviar un mensaje si el usuario no está autenticado', () => {
        // Navegamos a la página de un producto
        cy.fixture('seedData').then((data) => {
            const product = data.products[0];
            cy.visit(`/products/leer/${product.id}`);
        });

        // Intentar enviar un mensaje
        const messageBody = "Hola, estoy interesado en tu producto.";
        cy.get('input[name="message[body]"]').type(messageBody);
        cy.get('button').contains('Crear').click();

        // Verificar que se redirige al usuario a la página de inicio de sesión
        cy.url().should('include', '/users/sign_in');
    });
});
