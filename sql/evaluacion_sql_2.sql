/*Para esta evaluación usaremos la BBDD de northwind con la que ya estamos familiarizadas de los ejercicios de pair programming.*/

USE northwind;

/*En esta evaluación tendréis que contestar a las siguientes preguntas:

1. Selecciona todos los campos de los productos
-Que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9 
-Que tengan stock en el almacén, y al mismo tiempo que sus precios unitarios estén entre 50 y 100. 
-Por último, ordena los resultados por código de proveedor de forma ascendente.*/

SELECT *
	FROM products AS p1
    WHERE supplier_id IN (SELECT supplier_id
							FROM products AS p2
							WHERE supplier_id = 1 OR supplier_id = 3 OR supplier_id BETWEEN 7 AND 9)
					AND units_in_stock IN (SELECT units_in_stock
											FROM products AS p3
                                            WHERE units_in_stock > 0)
					AND unit_price IN (SELECT unit_price
										FROM products AS p4
                                        WHERE unit_price BETWEEN 50 AND 100)                                        
		ORDER BY supplier_id;
        
        

/*2.Devuelve:
-El nombre y apellidos y el id de los empleados con códigos entre el 3 y el 6, 
-Además que hayan vendido a clientes que tengan códigos que comiencen con las letras de la A hasta la G. 
-Por último, en esta búsqueda queremos filtrar solo por aquellos envíos que la fecha de pedido este comprendida entre el 22 y el 31 de Diciembre de cualquier año.*/

SELECT employees2.employee_id, employees2.first_name, employees2.last_name
	FROM (SELECT *
			FROM employees
            WHERE employee_id BETWEEN 3 AND 6) AS employees2
    WHERE employee_id IN (SELECT orders.employee_id
							FROM orders
                            WHERE MONTH(order_date) = 12 AND DAY(order_date) BETWEEN 22 AND 31
                            AND customer_id REGEXP '^[A-G]'); 
							
    

/*3.Calcula:
-El precio de venta de cada pedido una vez aplicado el descuento. 
Muestra el id del la orden, el id del producto, el nombre del producto, el precio unitario, la cantidad, el descuento
y el precio de venta después de haber aplicado el descuento.*/
 
 SELECT order_details.order_id, order_details.product_id, products.product_name, order_details.unit_price, order_details.quantity, 
			ROUND(order_details.discount, 3) AS discount, 
			ROUND((order_details.unit_price * order_details.discount), 2) AS unit_price_discount, 
            ROUND((order_details.unit_price * order_details.quantity * order_details.discount), 2) AS total_price
	FROM order_details
    INNER JOIN products
    ON order_details.product_id = products.product_id;
 
 
/*4.Usando una subconsulta:
-Muestra los productos cuyos precios estén por encima del precio medio total de los productos de la BBDD.*/

SELECT product_id, product_name, unit_price 
	FROM products
    WHERE unit_price > (SELECT AVG(UNIT_PRICE) AS media
							FROM products);
                            
                            
/*-¿Qué productos ha vendido cada empleado y cuál es la cantidad vendida de cada uno de ellos?*/

SELECT orders.employee_id, order_details.quantity, order_details.product_id
	FROM  orders
    NATURAL JOIN order_details;
                              

/*5.Basándonos en la query anterior:
-¿Qué empleado es el que vende más productos? Soluciona este ejercicio con una subquery*/

SELECT employee_id, quantity
FROM orders AS P1
NATURAL JOIN order_details
WHERE quantity >= ALL (SELECT SUM(order_details.quantity)
						FROM  orders AS P2
						NATURAL JOIN order_details
						WHERE P1.employee_id = P2.employee_id);
            

    
/*BONUS ¿Podríais solucionar este mismo ejercicio con una CTE?*/

WITH consulta1 AS (SELECT employee_id, SUM(order_details.quantity) AS CantidadxVendedor 
					FROM  orders
					NATURAL JOIN order_details
					GROUP BY employee_id)
SELECT MAX(CantidadxVendedor)
	FROM consulta1;