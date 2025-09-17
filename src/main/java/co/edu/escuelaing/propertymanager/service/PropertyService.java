package co.edu.escuelaing.propertymanager.service;

import co.edu.escuelaing.propertymanager.model.Property;
import java.util.List;

public interface PropertyService {
    Property createProperty(Property property);

    List<Property> getAllProperties();

}
