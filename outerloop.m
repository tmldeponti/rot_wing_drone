syms 'theta' 'phi' 'psi' Tbx Tbz L m 'Lambda'
Mnb(theta,phi,psi) = [cos(theta)*cos(psi)-sin(phi)*sin(theta)*sin(psi), -cos(phi)*sin(psi), sin(theta)*cos(psi)+sin(phi)*cos(theta)*sin(psi);
    cos(theta)*sin(psi)+sin(phi)*sin(theta)*cos(psi),cos(phi)*cos(psi),sin(theta)*sin(psi)-sin(phi)*cos(theta)*cos(psi);
    -cos(phi)*sin(theta),sin(phi),cos(phi)*cos(theta)]
Tnbx(theta,phi,psi,Tbx) = Mnb(theta,phi,psi)*[Tbx;0;0]
Tnbz(theta,phi,psi,Tbz) = Mnb(theta,phi,psi)*[0;0;Tbz]
Tn(theta,phi,psi,Tbx,Tbz)=  Mnb(theta,phi,psi)*[Tbx;0;Tbz]
Lb(L) = [0;0;L]
Ln(phi,psi,L) = Mnb(0,phi,psi)*Lb(L)
Gt = [(diff(Tn,phi)/m).';
      (diff(Tn,theta)/m).';
      (diff(Tn,Tbz)/m).';
      (diff(Tn,Tbx)/m).';
      (diff(Tn,Lambda)/m).'].'
Gl = [(diff(Ln,phi)/m).';
      (diff(Ln,theta)/m).';
      (diff(Ln,Tbz)/m).';
      (diff(Ln,Tbx)/m).';
      (diff(Ln,Lambda)/m).'].'