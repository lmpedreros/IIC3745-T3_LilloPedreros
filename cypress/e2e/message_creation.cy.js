// Happy Path
describe('Formulario de envio de mensaje', () => {
    it('Permitir crear un mensaje con datos válidos', () => {
        cy.visit('http://localhost:5017');

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

        // Navegamos a la página de un producto
        cy.fixture('seedData').then((data) => {
            const product = data.products[0];
            cy.visit(`/products/leer/1`);
        });

        // Llenamos el formulario de mensaje y lo enviamos
        cy.fixture('seedData').then((data) => {
            const messageBody = "Hola, estoy interesado en tu producto.";
            cy.get('input[placeholder="Hola, ¿hay stock en color blanco?..."]').type(messageBody);
            cy.get('button').contains('Crear').click();
        });

        // Verificamos que el mensaje se haya enviado correctamente
        cy.contains('Pregunta creada correctamente!').should('be.visible');
    });

    // ======================================================================================================================================
    // Caso alternativo 1
    it('No permitir enviar un mensaje sin cuerpo', () => {
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

        // Navegamos a la página de un producto
        cy.fixture('seedData').then((data) => {
            const product = data.products[0];
            cy.visit(`/products/leer/1`);
        });

        // Intentar enviar un mensaje vacío
        cy.get('button').contains('Crear').click();

        // Verificar que se muestra el mensaje de error
        cy.contains('Hubo un error al guardar la pregunta. ¡Completa todos los campos solicitados!').should('be.visible');
    });

    // ======================================================================================================================================
    // Caso alternativo 2
    it('Mostrar mensaje "Debes iniciar sesión para realizar preguntas" si el usuario no está autenticado', () => {

        // Navegamos a la página de un producto
        cy.visit('/products/leer/1');

        // Verificamos que el mensaje "Debes iniciar sesión para realizar preguntas" se muestra
        cy.contains('Debes iniciar sesión para realizar preguntas.').should('be.visible');

        // Verificamos que el input de mensaje no está presente
        cy.get('input[placeholder="Hola, ¿hay stock en color blanco?..."]').should('not.exist');
    });
});
