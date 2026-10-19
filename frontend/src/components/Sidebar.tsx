import { useState } from "react";
import { Users, Plus, Search, Loader2, MapPin } from "lucide-react";
import type { ClienteResponse } from "../services/api";
import { CreateClientModal } from "./CreateClientModal";

interface SidebarProps {
  clients: ClienteResponse[];
  selectedClientId: string | null;
  onSelectClient: (id: string) => void;
  onRefreshClients: () => void;
  isLoading?: boolean; 
}

export function Sidebar({ 
  clients, 
  selectedClientId, 
  onSelectClient, 
  onRefreshClients, 
  isLoading = false 
}: SidebarProps) {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState(""); 
  // 1. Nuevo estado para el filtro de sede
  const [sedeFilter, setSedeFilter] = useState(""); 

  // 2. Lógica de filtrado combinada (Buscador + Selector de Sede)
  const filteredClients = clients.filter((c) => {
    // Verifica si coincide con el texto del buscador
    const matchesSearch = c.nombre.toLowerCase().includes(searchTerm.toLowerCase());
    // Verifica si coincide con la sede seleccionada (si sedeFilter está vacío, devuelve true para todos)
    const matchesSede = sedeFilter === "" || c.nombre.includes(sedeFilter);
    
    // Retorna el cliente solo si cumple AMBAS condiciones
    return matchesSearch && matchesSede;
  });

  return (
    <aside className="glass sidebar">
      <div className="sidebar-header">
        <Users size={20} />
        Clientes
      </div>
      
      <div className="sidebar-filters">
        <div className="field-with-icon">
          <Search size={16} />
          <input
            type="text"
            placeholder="Buscar cliente..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        <div className="field-with-icon">
          <MapPin size={16} />
          <select value={sedeFilter} onChange={(e) => setSedeFilter(e.target.value)}>
            <option value="">Todas las sedes</option>
            <option value="Valle">Valle</option>
            <option value="Bogotá">Bogotá</option>
            <option value="Medellín">Medellín</option>
          </select>
        </div>
      </div>

      <div className="client-list">
        {isLoading ? (
          <div className="sidebar-state">
            <Loader2 className="animate-spin" size={28} />
            <span>Cargando clientes...</span>
          </div>
        ) : filteredClients.length === 0 ? (
          <p className="sidebar-state">
            {clients.length === 0
              ? "No hay clientes registrados."
              : "No se encontraron resultados."}
          </p>
        ) : (
          filteredClients.map((c) => (
            <div
              key={c.id}
              className={`client-item ${selectedClientId === c.id ? 'active' : ''}`}
              onClick={() => onSelectClient(c.id)}
            >
              <h3>{c.nombre}</h3>
              <div className="client-item-meta">
                <span className="status-badge">Activo</span>
                <span className="client-item-id">{c.id.slice(0, 8)}</span>
              </div>
            </div>
          ))
        )}
      </div>

      <div className="sidebar-footer">
        <button className="btn-secondary" onClick={() => setIsModalOpen(true)}>
          <Plus size={18} />
          Crear Cliente
        </button>
      </div>

      {isModalOpen && (
        <CreateClientModal 
          onClose={() => setIsModalOpen(false)} 
          onSuccess={() => {
            onRefreshClients();
            setIsModalOpen(false);
          }} 
        />
      )}
    </aside>
  );
}