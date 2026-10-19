import { useEffect, useState } from "react";
import { useAuth } from "@clerk/clerk-react";
import { MousePointerClick } from "lucide-react";
import { Navbar } from "./components/Navbar";
import { Sidebar } from "./components/Sidebar";
import { ClientDashboard } from "./components/ClientDashboard";
import { getClients, setupAxiosInterceptors } from "./services/api";
import type { ClienteResponse } from "./services/api";

function App() {
  const { getToken } = useAuth(); // Extraemos el token de la sesión actual de Clerk
  const [clients, setClients] = useState<ClienteResponse[]>([]);
  const [selectedClientId, setSelectedClientId] = useState<string | null>(null);
  const [isApiReady, setIsApiReady] = useState(false); // Estado para evitar peticiones sin token
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const loadClients = async () => {
    // 2. Activamos el círculo de progreso antes de la petición
    setIsLoading(true); 
    try {
      const data = await getClients();
      setClients(data);
    } catch (error) {
      console.error("Failed to fetch clients", error);
    } finally {
      // 3. El bloque 'finally' se ejecuta SIEMPRE (si sale bien o si hay error)
      // Así nos aseguramos de apagar el cargador pase lo que pase.
      setIsLoading(false);
    }
  };

  // 1. Configuramos Axios para que inyecte el token de Clerk
  useEffect(() => {
    setupAxiosInterceptors(() => getToken());
    setIsApiReady(true);
  }, [getToken]);

  // 2. Cargamos los datos SOLO cuando Axios ya está configurado
  useEffect(() => {
    if (isApiReady) {
      loadClients();
    }
  }, [isApiReady]);

  return (
    <>
      <Navbar />
      <main className="layout-main">
        <Sidebar 
          clients={clients} 
          isLoading={isLoading} // <-- Le pasas el booleano aquí
          selectedClientId={selectedClientId}
          onSelectClient={setSelectedClientId}
          onRefreshClients={loadClients}
        />
        
        {selectedClientId ? (
          <ClientDashboard clientId={selectedClientId} />
        ) : (
          <div className="glass empty-state">
            <div className="empty-state-icon">
              <MousePointerClick size={28} />
            </div>
            <h2>Bienvenido a DigitacionApp</h2>
            <p>Selecciona un cliente en la barra lateral para ver su flota y sus inspecciones.</p>
          </div>
        )}
      </main>
    </>
  );
}

export default App;