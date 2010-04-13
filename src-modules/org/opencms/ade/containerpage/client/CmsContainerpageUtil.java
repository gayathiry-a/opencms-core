/*
 * File   : $Source: /alkacon/cvs/opencms/src-modules/org/opencms/ade/containerpage/client/Attic/CmsContainerpageUtil.java,v $
 * Date   : $Date: 2010/04/13 14:27:44 $
 * Version: $Revision: 1.2 $
 *
 * This library is part of OpenCms -
 * the Open Source Content Management System
 *
 * Copyright (C) 2002 - 2009 Alkacon Software (http://www.alkacon.com)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * For further information about Alkacon Software, please see the
 * company website: http://www.alkacon.com
 *
 * For further information about OpenCms, please see the
 * project website: http://www.opencms.org
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

package org.opencms.ade.containerpage.client;

import org.opencms.ade.containerpage.client.draganddrop.CmsContainerDragHandler;
import org.opencms.ade.containerpage.client.draganddrop.CmsDragContainerElement;
import org.opencms.ade.containerpage.client.draganddrop.CmsDragTargetContainer;
import org.opencms.ade.containerpage.client.ui.CmsElementOptionBar;
import org.opencms.ade.containerpage.client.ui.CmsToolbarClipboardMenu;
import org.opencms.ade.containerpage.client.ui.I_CmsContainerpageToolbarButton;
import org.opencms.ade.containerpage.shared.CmsContainerElement;
import org.opencms.ade.containerpage.shared.I_CmsContainerpageProviderConstants;
import org.opencms.gwt.client.draganddrop.I_CmsDragTarget;
import org.opencms.gwt.client.util.CmsDomUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.Element;

/**
 * Utility class for the container-page editor.<p>
 * 
 * @author Tobias Herrmann
 * 
 * @version $Revision: 1.2 $
 * 
 * @since 8.0.0
 */
public class CmsContainerpageUtil {

    /** List of buttons of the tool-bar. */
    private List<I_CmsContainerpageToolbarButton> m_toolbarButtons;

    private CmsToolbarClipboardMenu m_clipboard;

    /**
     * Constructor.<p>
     * 
     * @param toolbarButtons the tool-bar buttons of the container-page editor
     */
    public CmsContainerpageUtil(List<I_CmsContainerpageToolbarButton> toolbarButtons) {

        m_toolbarButtons = toolbarButtons;
        Iterator<I_CmsContainerpageToolbarButton> it = m_toolbarButtons.iterator();
        while (it.hasNext()) {
            I_CmsContainerpageToolbarButton button = it.next();
            if (button.getName().equals(CmsToolbarClipboardMenu.BUTTON_NAME)) {
                m_clipboard = (CmsToolbarClipboardMenu)button;
                break;
            }

        }
    }

    /**
     * The method will create {@link CmsDragTargetContainer} object for all given containers
     * by converting the associated DOM elements. The contained elements will be transformed into {@link CmsDragContainerElement}.<p>
     * 
     * @param containers the container data
     * 
     * @return the drag target containers
     */
    public Map<String, CmsDragTargetContainer> consumeContainers(Map<String, CmsContainerJso> containers) {

        Map<String, CmsDragTargetContainer> result = new HashMap<String, CmsDragTargetContainer>();
        Iterator<CmsContainerJso> it = containers.values().iterator();
        while (it.hasNext()) {
            CmsContainerJso container = it.next();
            CmsDragTargetContainer dragContainer = new CmsDragTargetContainer(container);
            consumeContainerElements(dragContainer);
            result.put(container.getName(), dragContainer);
        }

        return result;
    }

    /**
     * Transforms all contained elements into {@link CmsDragContainerElement}.<p>
     * 
     * @param container the container
     */
    public void consumeContainerElements(CmsDragTargetContainer container) {

        List<CmsDragContainerElement> elements = new ArrayList<CmsDragContainerElement>();
        // the drag element widgets are created from the existing DOM elements,
        // to establish the internal widget hierarchy the elements need to be removed from the DOM and added as widgets to the root panel
        Element child = (Element)container.getElement().getFirstChildElement();
        while (child != null) {
            if (CmsDomUtil.hasClass(I_CmsContainerpageProviderConstants.CLASS_CONTAINER_ELEMENTS, child)) {
                String clientId = child.getAttribute("title");
                String sitePath = child.getAttribute("alt");
                String noEditReason = child.getAttribute("rel");
                Element elementRoot = (Element)child.getFirstChildElement();
                DOM.removeChild(child, elementRoot);
                elements.add(createElement(elementRoot, container, clientId, sitePath, noEditReason));
            } else if (CmsDomUtil.hasClass(I_CmsContainerpageProviderConstants.CLASS_SUB_CONTAINER_ELEMENTS, child)) {
                // TODO: handle sub-container
            }
            DOM.removeChild(container.getElement(), child);
            child = (Element)container.getElement().getFirstChildElement();
        }

        // re-append the element widgets by adding them to the root panel
        Iterator<CmsDragContainerElement> it = elements.iterator();
        while (it.hasNext()) {
            container.add(it.next());
        }
    }

    /**
     * Creates an drag container element.<p>
     * 
     * @param element the DOM element
     * @param dragParent the drag parent
     * @param clientId the client id
     * @param sitePath the element site-path
     * @param noEditReason the no edit reason
     * 
     * @return the draggable element
     */
    public CmsDragContainerElement createElement(
        com.google.gwt.user.client.Element element,
        I_CmsDragTarget dragParent,
        String clientId,
        String sitePath,
        String noEditReason) {

        CmsDragContainerElement dragElement = new CmsDragContainerElement(
            element,
            dragParent,
            clientId,
            sitePath,
            noEditReason);
        CmsContainerDragHandler.get().registerMouseHandler(dragElement);
        CmsElementOptionBar optionBar = CmsElementOptionBar.createOptionBarForElement(dragElement, m_toolbarButtons);
        dragElement.setElementOptionBar(optionBar);

        return dragElement;
    }

    /**
     * Creates an drag container element.<p>
     * 
     * @param containerElement the container element data 
     * @param dragParent the drag parent
     * @param containerType the container type
     * 
     * @return the draggable element
     * @throws Exception if something goes wrong
     */
    public CmsDragContainerElement createElement(
        CmsContainerElement containerElement,
        I_CmsDragTarget dragParent,
        String containerType) throws Exception {

        com.google.gwt.user.client.Element element = CmsDomUtil.createElement(containerElement.getContents().get(
            containerType));
        return createElement(
            element,
            dragParent,
            containerElement.getClientId(),
            containerElement.getFile(),
            containerElement.getNoEditReason());
    }

    /**
     * Returns the clipboard.<p>
     *
     * @return the clipboard
     */
    public CmsToolbarClipboardMenu getClipboard() {

        return m_clipboard;
    }

}