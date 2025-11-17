
/**
 * Write a description of class Paciente here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class TS_entry
{
   private String id;
   private int tipo;
   private int nElem;
   private int tipoBase;

   private int tam;

    public TS_entry(String umId, int umTipo, int ne, int umTBase) {
        id = umId;
        tipo = umTipo;
        nElem = ne;
        tipoBase = umTBase;

        // se não for array (nElem == -1), assume 4 bytes
        // se for array, nElem * 4
        if (nElem == -1) {
            tam = 4;
        } else {
            tam = nElem * 4;
        }
    }

   public TS_entry(String umId, int umTipo) {
        this(umId, umTipo, -1, -1);
    }


   public String getId() {
       return id; 
   }

   public int getTipo() {
       return tipo; 
   }
   
   public int getNumElem() {
       return nElem; 
   }

   public int getTipoBase() {
       return tipoBase; 
   }

   public int getTam() {
        return tam;
    }

    public void setTam(int t) {
        tam = t;
    }

   
   public String toString() {
        String aux = (nElem != -1) ? "\t array(" + nElem + "): " + tipoBase : "";
        // opcional: mostrar tam também, se quiser
        return "Id: " + id + "\t tipo: " + tipo + aux + "\t tam: " + tam;
    }
}