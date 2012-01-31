/*
 IndivoPrincipal.h
 IndivoFramework
 
 Created by Indivo Class Generator on 1/31/2012.
 Copyright (c) 2012 Children's Hospital Boston
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

#import "IndivoDocument.h"


	

/**
 *	A class representing "indivo:Principal" objects.
 */
@interface IndivoPrincipal : IndivoDocument

@property (nonatomic, strong) INString *type;					///< Must not be nil nor return YES on isNull
@property (nonatomic, strong) INString *fullname;					///< Must not be nil nor return YES on isNull (minOccurs = 1)


@end