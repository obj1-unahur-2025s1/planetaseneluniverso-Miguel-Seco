class Persona{
  var edad 
  var recursos = 20
  method recursos() = recursos
  method cumplirAños(){
    edad +=1
  }
  method initialize(){
    if( edad < 0){
      self.error("la edad ingresa no corresponde a una edad valida")
    }
  }
  method esDestacada() = edad.between(18, 65) || recursos > 30

  method ganarMonedad(cantMonedas){
    recursos += cantMonedas 
  }

  method gastarMonedad(cantMonedas){
    recursos -= cantMonedas 
  }
  method trabajarDurante(unTiempo,unPlaneta){

  }
}

class Construcciones {
  var property valor =  0
}

class Muralla inherits Construcciones{
  var longitud
  override method valor() = 10 * longitud
}


class Museo inherits Construcciones{
  const superficieCubierta 
  var indiceDeImportancia
  method initialize(){
    if( !indiceDeImportancia.between(1,5) and superficieCubierta < 0){
      self.error("el indice de importancia debe ser un valor entre 1 y 5 o la superficie cubierta debe ser mayor a 0")
    }
  }
  override method valor() = superficieCubierta * indiceDeImportancia
}

class Planeta{
  const habitantes = []
  const construcciones = []
  const delegacionDiplomatica = #{}
  method esHabitante(unHabitante) = habitantes.contains(unHabitante)
  method agregarHabitante(unHabitante){
    habitantes.add(unHabitante)
  }
  method quitarHabitante(unHabitante){
    habitantes.remove(unHabitante)
  }
  method agregarConstruccion(unaConstruccion){
    construcciones.add(unaConstruccion)
  }
  method quitarConstruccion(unaConstruccion){
    construcciones.remove(unaConstruccion)
  }
  method cantidadDeMiembrosDelegacion() = delegacionDiplomatica.size()

  method habitantesDestacados() = habitantes.filter({h => h.esDestacada()})
  method habitanteConMasRecursos() = habitantes.max({h => h.recursos()})
  method crearDelegacionDiplomatica(){
    delegacionDiplomatica.addAll(self.habitantesDestacados())
    delegacionDiplomatica.add(self.habitanteConMasRecursos())
  }
  method esValioso() = construcciones.sum({c => c.valor()}) > 100
}
class Productor inherits Persona{
  const tecnicasQueConoce = ["cultivo"]
  method cantTecnicasQueConoce() = tecnicasQueConoce.size()
  override method recursos() = super() * self.cantTecnicasQueConoce()
  override method esDestacada() = super() || self.cantTecnicasQueConoce() > 5
  method realizarTecnicaDurante(tiempo,tecnica){
    if( self.conoceTecnica(tecnica))
      self.ganarMonedad( 3 * tiempo)
    else self.gastarMonedad(1)
  }
  method conoceTecnica(unaTecnica) = tecnicasQueConoce.contains(unaTecnica)
  method aprenderTecnica(unaTecnica){
    tecnicasQueConoce.add(unaTecnica)
  }
  override method trabajarDurante(unTiempo,unPlaneta){
    if(unPlaneta.esHabitante(self))
      self.realizarTecnicaDurante(unTiempo,self.ultimaTecnicaAprendida())
  }
  method ultimaTecnicaAprendida() = tecnicasQueConoce.last()
}
class Constructor inherits Persona{
  var inteligencia
  const contruccionesRealizadas = []
  var regionDondeVive
  method agregarConstruccionRealizada(unaConstruccion){
    contruccionesRealizadas.add(unaConstruccion)
  }
  method cantConstruccionesRealizadas() = contruccionesRealizadas.size()
  override method recursos() = super() + 10 * self.cantConstruccionesRealizadas()
  override method esDestacada() = self.cantConstruccionesRealizadas() > 5
  override method trabajarDurante(unTiempo,unPlaneta){
    self.construir(unTiempo,unPlaneta)
  }
  method construir(tiempo,planeta){
    if (regionDondeVive == "montaña"){ planeta.agregarConstruccion(new Muralla(longitud = tiempo / 2 )) }
    else if (regionDondeVive == "costa"){planeta.agregarConstruccion(new Museo(superficieCubierta = tiempo,indiceDeImportancia = 1))}
    else if (regionDondeVive == "llanura"){ self.construirEnLlanura(tiempo,planeta)}
    else self.construirEnDesierto(tiempo,planeta) 
    planeta.agregarConstruccion()
    self.gastarMonedad(5)
  }
  method construirEnLlanura(tiempo,planeta) {
    if(!self.esDestacada()){planeta.agregarConstruccion(new Muralla(longitud = tiempo / 2))}
    else planeta.agregarConstruccion(new Museo(superficieCubierta= tiempo, indiceDeImportancia = 3))
  }
  method construirEnDesierto(unTiempo, unPlaneta){
        if (regionDondeVive == "desierto" and inteligencia >10) self.construir(new Muralla(longitud=unTiempo) , unPlaneta)
    }
}



