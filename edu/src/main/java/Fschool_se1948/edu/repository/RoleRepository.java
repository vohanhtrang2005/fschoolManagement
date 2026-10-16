package Fschool_se1948.edu.repository;

import Fschool_se1948.edu.entity.Role;
import Fschool_se1948.edu.entity.RoleName;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByName(RoleName name);
}
