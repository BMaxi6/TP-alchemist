object itemDeRecoleccion{}

object material1 {
	method calidad() {
		return 60
	}
}

object material2 {
	method calidad() {
		return 40
	}
}

object materialMistico {
	method esMistico() {
		return true
	}
}

object materialNoMistico {
	method esMistico(){
		return false
	}
}	

object alquimista{
	
	var itemsDeCombate = []
	var itemsDeRecoleccion = []
	
	method agregarItemDeRecoleccion(unItem){
		itemsDeRecoleccion.add(unItem)	
	}
	
	method agregarItemDeCombate(unItem){
		itemsDeCombate.add(unItem)
	}
	
//	1
	method tieneCriterio(){
		return	self.cantidadEfectivos() >= self.cantidadItemsDeCombate() / 2
		}
	
	method cantidadItemsDeCombate(){
		return itemsDeCombate.size()
	}
	
	method cantidadEfectivos(){
		return itemsDeCombate.count({
			item=>item.esEfectivo()
			})
		}
//  2
	method esBuenExplorador(){
		return self.cantidadItemsDeRecoleccion() >= 3
		}
	
	method cantidadItemsDeRecoleccion(){
		return itemsDeRecoleccion.asSet().size()
		}
		
//  3
	method capacidadOfensiva(){
		return self.sumaCapacidades()
		}
	
	method sumaCapacidades(){
		return itemsDeCombate.sum({
			items => items.capacidad()
			})
	}

//  4
	method esProfesional(){
		return self.calidadPromedio() >= 50 and self.todosItemsEfectivos() and self.esBuenExplorador() 
		}
		
	method calidadPromedio(){
		return itemsDeCombate.sum({
			item => item.calidadItem()
			}) / self.cantidadItemsDeCombate()
		}
	
	method todosItemsEfectivos(){
		return itemsDeCombate.all({
			item => item.esEfectivo()
			})
		}
}

object bomba {
	var danio
	var materiales = []
	
	method agregarMaterial( unMaterial ) {
		return materiales.add( unMaterial )
	}
	
	method definirDanio ( unDanio ) {
		danio = unDanio
	}
	
	method esEfectivo(){
		return danio > 100
		}
	method calidadItem(){
		return materiales.min({
			material => material.calidad()
		}).calidad()
	}
	method capacidad(){
		return danio/2
		}
}

object potenciador{
	var potencia
	var materiales = []
	
	method definirPotencia(unaPotencia) {
		potencia = unaPotencia
	}
	
	method agregarMaterial( unMaterial ) {
		return materiales.add( unMaterial )
	}

	method esEfectivo(){
		return potencia > 0 and self.noTieneMistico()
		}
	method noTieneMistico(){
		return materiales.any({
			material => material.esMistico().negate()
			})
		}
	method capacidad(){
		if(self.noTieneMistico()){
			return 5
			}else{
				return  self.cantidadDeMisticos()*12
			}
		}
	method cantidadDeMisticos(){
		return materiales.count({
			material => material.esMistico()
		 })
		}
	method calidadItem(){
		return self.promedioDeLosDosMayores()
	}
	method promedioDeLosDosMayores(){
		return self.calidadDosMayores()/2
	}
	method calidadDosMayores(){
		return (self.dosMayores()).sum({
			material => material.calidad()
		})
	}
	
	method dosMayores() {
		return materiales.sortedBy({
			unMaterial, otroMaterial => unMaterial.calidad() > otroMaterial.calidad()
		}).take(2)
	}
}


object pocion{ 
	var poderCurativo
	var materiales = []
	
	method definirPoderCurativo (unPoder) {
		poderCurativo = unPoder
	}
	
	method agregarMaterial( unMaterial ) {
		return materiales.add( unMaterial )
	}
	
	method esEfectivo(){
		return poderCurativo > 50 and self.tieneMaterialMistico()
		}
		
	method calidadMateriales(){
		return materiales.sum({
			material => material.calidad()
			})
		}
		
	method tieneMaterialMistico(){
		return materiales.any({material=>material.esMistico()})
		}
		
	method capacidad(){
		return poderCurativo + 10 * self.cantidadMaterialesMisticos()
		}
		
	method cantidadMaterialesMisticos(){
		return materiales.count({
			material => material.esMistico()
			})
		}
		
	method calidadItem(){
		if(self.tieneMaterialMistico()){
			return self.primerMaterialMistico().calidad()
		}else{
			return materiales.first().calidad()
		}
	}
	
	method primerMaterialMistico() {
		return materiales.filter({
			material => material.esMistico()
		}).first()
	}
}