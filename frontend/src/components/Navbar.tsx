import { LayoutDashboard, LogOut } from "lucide-react";
import { useClerk } from "@clerk/clerk-react";

export function Navbar() {
  const { signOut } = useClerk();

  return (
    <nav className="navbar">
      <div className="navbar-logo">
        <LayoutDashboard size={20} />
      </div>
      <span className="navbar-title">DigitacionApp</span>
      <button className="navbar-logout" onClick={() => signOut()}>
        <LogOut size={18} />
        Cerrar sesión
      </button>
    </nav>
  );
}
